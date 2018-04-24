//
//  GameScene.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/5/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
  weak var gameViewController: GameViewController?
  
  var worldNode: SKNode!
  var bgNode: SKNode!
  var topBGNode: SKNode!
  var fgNode: SKNode!
  var originalFGLayerNode: SKSpriteNode!
  var player: PlayerNode!
  
  var bgNodeHeight: CGFloat!
  var lastFGLayerPosition = CGPoint.zero
  var levelPositionY: CGFloat = 0.0
  
  var countOfSceneLayers = 1
  var slagPoints = 0
  static var theme: String?
  
  var gameState = GameState.starting

  let motionManager = CMMotionManager()
  var xAcceleration = CGFloat(0)
  var hud = HUD()
  
  var startTime: TimeInterval = 0
  var elapsedTime: TimeInterval = 0
  var finishTime: TimeInterval = 0
  
  // MARK: - Class Methods
  class func sceneFor(challengeNumber: Int) -> SKScene? {
    if let scene = GameScene(fileNamed: "Challenge\(challengeNumber)") {
      return scene
    } else {
      let newChallengeTravels = ((challengeNumber / 100) + 1) * 100
      
      if let scene = GameScene(fileNamed: "Challenge\(newChallengeTravels)") {
        SessionData.sharedInstance.currentChallenge = newChallengeTravels
        return scene
      } else if let scene = GameScene(fileNamed: "Challenge1") {
        SessionData.sharedInstance.currentChallenge = 1
        return scene
      }
    }
    
    assertionFailure("Unable to load a scene file for challenge \(challengeNumber) or challenge 1.")
    return nil
  }
  
  // MARK: - SpriteKit Methods
  override func didMove(to view: SKView) {
    print("GameScene didMove()")
    physicsWorld.contactDelegate = self
    
    setupCoreMotion()
    setupNodes()
    setupHUD()
    
    let backgroundMusic = userData?["backgroundmusic"] as? String
    let introVoice = userData?["introvoice"] as? String
    GameScene.theme = userData?["theme"] as? String
    
    let bgMusic = backgroundMusic != nil ? backgroundMusic! : "lunarlove.wav"
    let iVoice = introVoice != nil ? introVoice! : "slagmanvoice.m4a"
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      run(SKAction.sequence([SKAction.playSoundFileNamed(iVoice, waitForCompletion: true),
                             SKAction.run {
                              if UserDefaults.standard.bool(forKey: SettingsKeys.music) == true {
                                self.playBackgroundMusic(name: bgMusic)
                              }}]))
    } else {
      run(SKAction.run {
        if UserDefaults.standard.bool(forKey: SettingsKeys.music) == true {
          self.playBackgroundMusic(name: bgMusic)
        }
      })
    }
    UnPauseAnimations()
  }
  
  deinit {
    print("Deinit GameScene")
    motionManager.stopAccelerometerUpdates()
  }
  
  override func update(_ currentTime: TimeInterval) {
    if gameState == .playing {
      player.update()
      updateCamera()
      addLayers()
      
      if startTime == 0 {
        startTime = currentTime
      }
      
      elapsedTime = currentTime - startTime
      hud.updateSlagTimeLabel(time: elapsedTime)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameState == .starting {
      if let positionInScene = touches.first?.location(in: self) {
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
          if name == "homebutton"
          {
            if gameViewController != nil {
              gameViewController!.transitionToHome()
              return
            }
          }
        }
      }
      
      gameState = .playing
      hud.homeButton.removeFromParent()
      
      if let challengeLabel = fgNode.childNode(withName: "introlabel") as? SKLabelNode {
        challengeLabel.run(SKAction.scale(to: 0, duration: 0.5))
      }
      
      if let startLabel = fgNode.childNode(withName: "taplabel") as? SKLabelNode {
        startLabel.run(SKAction.scale(to: 0, duration: 0.5))
      }
    }
    
    // Initial player jet boost, after tapping to start the level.
    player.playerState = .boosting
  }
  
  // MARK: - Setup Methods
  private func setupCoreMotion() {
    motionManager.accelerometerUpdateInterval = 0.2
    
    motionManager.startAccelerometerUpdates(to: OperationQueue()) { [weak self] accelerometerData, error in
      guard error == nil else {
        assertionFailure("Error during Accelerometer callback: \(String(describing: error))")
        return
      }
      
      guard let accelerometerData = accelerometerData else {
        assertionFailure("Data returned from Accelerometer callback is nil.")
        return
      }
      
      if let weakSelf = self {
        weakSelf.xAcceleration = CGFloat(accelerometerData.acceleration.x) * 0.75 + weakSelf.xAcceleration * 0.25
      }
    }
  }
  
  private func setupNodes() {
    worldNode = childNode(withName: "world")
    
    bgNode = worldNode.childNode(withName: "background")
    bgNodeHeight = bgNode.calculateAccumulatedFrame().height
    
    fgNode = worldNode.childNode(withName: "foreground")
    let fgLayerNode = fgNode.childNode(withName: "objectLayer") as! SKSpriteNode
    
    fgLayerNode.enumerateChildNodes(withName: "proximityslag") { (node, _) in
      if let slagNode = node as? SlagNode {
        slagNode.createPhysicsForProximitySlag()
      }
    }
    
    originalFGLayerNode = fgLayerNode.copy() as! SKSpriteNode
    lastFGLayerPosition = originalFGLayerNode.position
    
    player = fgNode.childNode(withName: "player") as! PlayerNode
    topBGNode = worldNode.childNode(withName: "backgroundtop")
    
    if let challengeLabel = fgNode.childNode(withName: "challengelabel") as? SKLabelNode {
      challengeLabel.text = "Slag Challenge \(SessionData.sharedInstance.currentChallenge)"
    }
    
    let cameraNode = SKCameraNode()
    cameraNode.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y - 300)
    addChild(cameraNode)
    camera = cameraNode
  }
  
  private func createLayers() {
    let lastLayerPosition = lastFGLayerPosition
    let newFGlayerNode = originalFGLayerNode.copy() as! SKSpriteNode
    lastFGLayerPosition.y = lastFGLayerPosition.y + newFGlayerNode.size.height
    newFGlayerNode.position = lastFGLayerPosition
    fgNode.addChild(newFGlayerNode)
    
    let bgOverlay = bgNode.childNode(withName: "overlay") as! SKSpriteNode
    let newBGOverlay = bgOverlay.copy() as! SKSpriteNode
    newBGOverlay.position.y = lastLayerPosition.y + bgOverlay.size.height
    bgNode.addChild(newBGOverlay)
    
    levelPositionY += bgNodeHeight
    UnPauseAnimations()
  }
  
  func setupHUD() {
    camera?.addChild(hud)
    hud.updateSlagTimeLabel(time: 0)
  }
  
  // MARK: - Update Methods
  // The challenge scene is built by stacking copies of the foreground overlay and background nodes
  // on top of the scene.
  // This function creates copies of new nodes and places them on the top of the scene.
  private func addLayers() {
    var layerCount = 2
    
    if let sceneLayerCount = userData?["layercount"] as? Int {
      layerCount = sceneLayerCount
    }
    
    if countOfSceneLayers >= layerCount {
      return
    }
    
    if camera!.position.y > (levelPositionY - size.height) {
      // Create a copy of the foreground and background layer nodes, and add them to the top of the scene.
      print("New Layers")
      countOfSceneLayers += 1
      createLayers()
      
      topBGNode.position = CGPoint(x: topBGNode.position.x, y: levelPositionY + originalFGLayerNode.size.height)
    }
  }
  
  private func updateCamera() {
    let playerPositionScene = convert(player.position, from: fgNode)
    
    if playerPositionScene.y < -600 {
      return
    }
    
    let targetPositionY = playerPositionScene.y + (size.height * 0.15)
    let diff = (targetPositionY - camera!.position.y) * 0.2
    let newCameraPositionY = camera!.position.y + diff
    camera!.position.y = newCameraPositionY
  }
  
  // MARK: - Utility Methods
  func sceneCropAmount() -> CGFloat {
    let scale = view!.bounds.size.height / size.height
    let scaledWidth = size.width * scale
    let scaledOverlap = scaledWidth - view!.bounds.size.width
    return scaledOverlap / scale
  }
  
  func playBackgroundMusic(name: String) {
    if let _ = childNode(withName: "backgroundmusic") {
      return
    }
    
    let music = SKAudioNode(fileNamed: name)
    music.name = "backgroundmusic"
    music.autoplayLooped = true
    addChild(music)
  }
  
  func UnPauseAnimations() {
    enumerateChildNodes(withName: "//rotatinggate") { (node, _) in
      node.isPaused = false
    }
  }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene {
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PhysicsCategory.Contactable:
      if let boostNode = other.node as? BoostNode {
        let boostParentNode = boostNode.parent
        
        // If it's a node at the finish line.
        if let _ = boostNode.userData?["finish"] {
          if gameState == .challengeEnded {
            return
          }
          
          print("Challenge ended.")
          gameState = .challengeEnded
          
          finishTime = elapsedTime
          
          if SessionData.sharedInstance.currentChallenge > 0 {
            run(SKAction.afterDelay(1.5, runBlock: {
              if let challengeCompleted = ChallengeCompletedScene(fileNamed: "ChallengeCompleted") {
                challengeCompleted.challengeNumberCompleted = SessionData.sharedInstance.currentChallenge
                challengeCompleted.slagCreated = self.slagPoints
                challengeCompleted.slagTime = self.finishTime
                challengeCompleted.scaleMode = .aspectFill
                challengeCompleted.gameViewController = self.gameViewController
                self.view!.presentScene(challengeCompleted, transition: SKTransition.doorway(withDuration:1))
              }
            }))
          } else {
            run(SKAction.afterDelay(1.5, runBlock: {
              if let tutorialCompleted = TutorialCompletedScene(fileNamed: "TutorialCompleted") {
                tutorialCompleted.challengeNumberCompleted = SessionData.sharedInstance.currentChallenge
                tutorialCompleted.slagCreated = self.slagPoints
                tutorialCompleted.slagTime = self.finishTime
                tutorialCompleted.scaleMode = .aspectFill
                tutorialCompleted.gameViewController = self.gameViewController
                self.view!.presentScene(tutorialCompleted, transition: SKTransition.doorway(withDuration:1))
              }
            }))
          }
          
          boostNode.finishExplosion()
        // It's just a regular power node.
        } else {
          if boostParentNode == nil {
            return
          }
          
          let slagNode = boostNode.createSlagNode()
          
          run(SKAction.afterDelay(0.5, runBlock: {
            assert(boostParentNode != nil, "Boost parent node is nil.")
            boostParentNode?.addChild(slagNode)
          }))
          
          slagPoints += 10
          boostNode.explode()
        }
        player.powerBoost()
      } else if let slagNode = other.node as? SlagNode, let _ = other.node?.userData?["proximity"] {
        slagNode.contactWithProximitySlag(player: player)
      }
    case PhysicsCategory.Collidable:
      if gameState == .playing {
        // If Slagman should die upon touching this object.
        if other.node?.userData?["deadly"] != nil {
          player.playerState = .dead
          gameState = .challengeEnded
          
          run(SKAction.afterDelay(2.0, runBlock: {
            if let scene = GameScene.sceneFor(challengeNumber: SessionData.sharedInstance.currentChallenge) {
              scene.scaleMode = .aspectFill
              
              let gameScene = scene as! GameScene
              gameScene.gameViewController = self.gameViewController
              
              self.view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
            }
          }))
        }
      }
    default:
      break
    }
  }
}
