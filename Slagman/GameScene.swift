//
//  GameScene.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/5/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import CoreMotion

var totalSlagsSinceLastCrash = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
  var worldNode: SKNode!
  var bgNode: SKNode!
  var topBGNode: SKNode!
  var fgNode: SKNode!
  var lastFGLayerNode: SKSpriteNode!
  var finishGateNode: SKNode!
  var player: PlayerNode!
  
  var bgNodeHeight: CGFloat!
  var lastFGLayerPosition = CGPoint.zero
  var levelPositionY: CGFloat = 0.0
  
  var countOfSceneLayers = 1
  let maximumNumberOfSceneLayers = 2
  var currentChallengeNumber = 1
  var countOfSlagsCreated = 0
  
  var gameState = GameState.starting

  let motionManager = CMMotionManager()
  var xAcceleration = CGFloat(0)
  
  let cameraNode = SKCameraNode()
  
  // MARK: - Class Methods
  class func sceneFor(challengeNumber: Int) -> SKScene? {
    if let scene = GameScene(fileNamed: "Challenge\(challengeNumber)") {
      scene.currentChallengeNumber = challengeNumber
      return scene
    } else if let scene = GameScene(fileNamed: "Challenge1") {
      scene.currentChallengeNumber = 1
      return scene
    }
    
    assertionFailure("Unable to load a scene file for challenge \(challengeNumber) or challenge 1.")
    return nil
  }
  
  override func sceneDidLoad() {
    addObservers()
  }
  
  // MARK: - SpriteKit Methods
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    setupCoreMotion()
    setupNodes()
    playBackgroundMusic(name: "backgroundmusic.wav")
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: nil) { [weak self] _ in
      self?.applicationWillResignActive()
    }
  }
  
  deinit {
    print("GameScene Deinit")
    motionManager.stopAccelerometerUpdates()
  }
  
  override func update(_ currentTime: TimeInterval) {
    if gameState == .playing {
      player.update()
      updateCamera()
      addLayers()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameState == .starting {
      gameState = .playing
      
      if let challengeLabel = fgNode.childNode(withName: "challengelabel") as? SKLabelNode {
        challengeLabel.run(SKAction.scale(to: 0, duration: 0.5))
      }
      
      if let startLabel = fgNode.childNode(withName: "startlabel") as? SKLabelNode {
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
    lastFGLayerNode = fgNode.childNode(withName: "objectLayer") as! SKSpriteNode
    lastFGLayerPosition = lastFGLayerNode.position
    
    player = fgNode.childNode(withName: "player") as! PlayerNode
    
    finishGateNode = lastFGLayerNode.childNode(withName: "finishgate_ref")
    finishGateNode.removeFromParent()
    
    topBGNode = worldNode.childNode(withName: "backgroundtop")
    topBGNode.removeFromParent()
    
    if let challengeLabel = fgNode.childNode(withName: "challengelabel") as? SKLabelNode {
      challengeLabel.text = "Challenge \(currentChallengeNumber)"
    }
    
    addChild(cameraNode)
    camera = cameraNode
  }
  
  private func createLayers() {
    if let fgOverlay = fgNode.childNode(withName: "objectLayer") {
      lastFGLayerNode = fgOverlay.copy() as! SKSpriteNode
      
      countOfSceneLayers += 1
      
      lastFGLayerPosition.y = lastFGLayerPosition.y + lastFGLayerNode.size.height
      lastFGLayerNode.position = lastFGLayerPosition
      
      fgNode.addChild(lastFGLayerNode)
      
      let bgOverlay = bgNode.childNode(withName: "overlay") as! SKSpriteNode
      let newBGOverlay = bgOverlay.copy() as! SKSpriteNode
      newBGOverlay.position.y = bgOverlay.position.y + bgOverlay.size.height
      bgNode.addChild(newBGOverlay)
      
      levelPositionY += bgNodeHeight
    } else {
      assertionFailure("Foreground object layer node is nil.")
    }
  }
  
  // MARK: - Update Methods
  // The challenge scene is built by stacking copies of the foreground overlay and background nodes
  // on top of the scene.
  // This function creates copies of new nodes and places them on the top of the scene.
  private func addLayers() {
    if countOfSceneLayers >= maximumNumberOfSceneLayers {
      return
    }
    
    if camera!.position.y > (levelPositionY - size.height) {
      // Create a copy of the foreground and background layer nodes, and add them to the top of the scene.
      createLayers()
      
      lastFGLayerNode.childNode(withName: "launchplatform_ref")?.removeFromParent()
      
      if countOfSceneLayers >= maximumNumberOfSceneLayers && gameState == .playing  {
        lastFGLayerNode.addChild(finishGateNode)
        topBGNode.position = CGPoint(x: topBGNode.position.x, y: levelPositionY + lastFGLayerNode.size.height)
        worldNode.addChild(topBGNode)
      }
    }
  }
  
  private func updateCamera() {
    let playerPositionScene = convert(player.position, from: fgNode)
    
    if playerPositionScene.y < 120 {
      return
    }
    
    let targetPositionY = playerPositionScene.y - (size.height * 0.10)
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
    if let backgroundMusic = childNode(withName: "backgroundmusic") {
      backgroundMusic.removeFromParent()
    }
    let music = SKAudioNode(fileNamed: name)
    music.name = "backgroundmusic"
    music.autoplayLooped = true
    addChild(music)
  }
}

// MARK: - Application Event Handlers
extension GameScene {
  func applicationWillResignActive() {
    print("applicationWillResignActive")
  }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene {
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PhysicsCategory.JetBoost:
      if let boostNode = other.node as? BoostNode {
        
        let boostParentNode = boostNode.parent
        
        if let _ = boostNode.userData?["slag"] {
          let slagNode = boostNode.createSlagNode()
          
          run(SKAction.afterDelay(0.5, runBlock: {
            assert(boostParentNode != nil, "Boost parent node is nil.")
            boostParentNode?.addChild(slagNode)
          }))
        } else {
          boostNode.removeFromParent()
        }
        
        countOfSlagsCreated += 1
        boostNode.explode()
      }
      
      player.powerBoost()
    case PhysicsCategory.CollidableObject:
      if let _ = other.node?.userData?["deadly"] {
        player.playerState = .dead
        totalSlagsSinceLastCrash = 0
        
        run(SKAction.afterDelay(2.0, runBlock: {
          if let scene = GameScene.sceneFor(challengeNumber: self.currentChallengeNumber) {
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
          }
        }))
      }
    case PhysicsCategory.NonCollidableObject:
      if other.node?.name == "finishboost" {
        if gameState == .challengeEnded {
          return
        }
        
        gameState = .challengeEnded
        print("Challenge ended.")
        
        totalSlagsSinceLastCrash += countOfSlagsCreated
        
        run(SKAction.afterDelay(1.0, runBlock: {
          if let challengeCompleted = ChallengeCompleted(fileNamed: "ChallengeCompleted") {
            challengeCompleted.challengeNumberCompleted = self.currentChallengeNumber
            challengeCompleted.slagsCreated = self.countOfSlagsCreated
            challengeCompleted.totalSlagsCreated = totalSlagsSinceLastCrash
            
            challengeCompleted.scaleMode = .aspectFill
            self.view!.presentScene(challengeCompleted, transition: SKTransition.doorway(withDuration:1))
          }
        }))
      }
    default:
      break
    }
  }
}