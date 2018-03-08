//
//  GameScene.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/5/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import CoreMotion

enum GameState {
  case levelStarting
  case playing
  case levelEnding
}

enum PlayerState {
  case standing
  case jetting
  case falling
  case dead
}

struct PhysicsCategory {
  static let None: UInt32              = 0        // 0
  static let Player: UInt32            = 0b1      // 1
  static let JetBoost: UInt32          = 0b10     // 2
  static let Platform: UInt32          = 0b100    // 4
  static let Edges: UInt32             = 0b1000   // 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  var worldNode: SKNode!
  var bgNode: SKNode!
  var fgNode: SKNode!
  var exitDoor: SKNode!
  
  var bgNodeHeight: CGFloat!
  var player: SKSpriteNode!
  
  var lastFGLayerNode: SKSpriteNode!
  var lastFGLayerPosition = CGPoint.zero
  var levelPositionY: CGFloat = 0.0
  var countOfLevelLayers = 1
  
  var gameState = GameState.levelStarting
  var playerState = PlayerState.standing
  
  let motionManager = CMMotionManager()
  var xAcceleration = CGFloat(0)
  
  let cameraNode = SKCameraNode()
  
  var playerAnimationJet: SKAction!
  var playerAnimationFall: SKAction!
  var playerAnimationSteerLeft: SKAction!
  var playerAnimationSteerRight: SKAction!
  var currentPlayerAnimation: SKAction!
  
  let soundBoost = SKAction.playSoundFileNamed("boost.wav", waitForCompletion: false)
  
  // MARK: - SpriteKit Methods
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    setupCoreMotion()
    setupNodes()
    
    playerAnimationJet = setupAnimationWithPrefix("player01_jet_", start: 1, end: 4, timePerFrame: 0.1)
    playerAnimationFall = setupAnimationWithPrefix("player01_fall_", start: 1, end: 3, timePerFrame: 0.1)
    playerAnimationSteerLeft = setupAnimationWithPrefix("player01_steerleft_", start: 1, end: 2, timePerFrame: 0.1)
    playerAnimationSteerRight = setupAnimationWithPrefix("player01_steerright_", start: 1, end: 2, timePerFrame: 0.1)
  }
  
  override func update(_ currentTime: TimeInterval) {
    if gameState == .playing {
      updatePlayer()
      updateCamera()
      updateLevel()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameState == .levelStarting {
      startGame()
    }
    
    jetBoostPlayer()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PhysicsCategory.JetBoost:
      jetBoostPlayer()
    default:
      break
    }
  }
  
  // MARK: - Setup Methods
  func setupCoreMotion() {
    motionManager.accelerometerUpdateInterval = 0.2
    
    let queue = OperationQueue()
    motionManager.startAccelerometerUpdates(to: queue) { accelerometerData, error in
      guard error == nil else {
        assertionFailure("Error during Accelerometer callback: \(String(describing: error))")
        return
      }
      
      guard let accelerometerData = accelerometerData else {
        assertionFailure("Data returned from Accelerometer callback is nil.")
        return
      }
      
      let acceleration = accelerometerData.acceleration
      self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
    }
  }
  
  func setupNodes() {
    worldNode = childNode(withName: "world")!

    bgNode = worldNode.childNode(withName: "background")!
    bgNodeHeight = bgNode.calculateAccumulatedFrame().height
    
    fgNode = worldNode.childNode(withName: "foreground")!
    lastFGLayerNode = fgNode.childNode(withName: "objectLayer") as! SKSpriteNode
    player = fgNode.childNode(withName: "player") as! SKSpriteNode
    
    exitDoor = lastFGLayerNode.childNode(withName: "exitDoor")!
    exitDoor.removeFromParent()
    
    lastFGLayerPosition = lastFGLayerNode.position
    
    addChild(cameraNode)
    camera = cameraNode
  }
  
  func createForegroundOverlay() {
    let fgOverlay = fgNode.childNode(withName: "objectLayer")
    lastFGLayerNode = fgOverlay!.copy() as! SKSpriteNode
    
    countOfLevelLayers += 1
    
    lastFGLayerPosition.y = lastFGLayerPosition.y + lastFGLayerNode.size.height
    lastFGLayerNode.position = lastFGLayerPosition
    
    fgNode.addChild(lastFGLayerNode)
    
    let bgOverlay = bgNode.childNode(withName: "overlay") as! SKSpriteNode
    let newBGOverlay = bgOverlay.copy() as! SKSpriteNode
    newBGOverlay.position.y = bgOverlay.position.y + bgOverlay.size.height
    bgNode.addChild(newBGOverlay)
    
    levelPositionY += bgNodeHeight
  }
  
  // MARK: - Update Methods
  func updatePlayer() {
    // Set velocity based on core motion
    player.physicsBody!.velocity.dx = xAcceleration * 1000.0
    
    // Wrap player around edges of screen
    var playerPosition = convert(player.position, from: fgNode)
    let rightLimit = size.width/2 - sceneCropAmount()/2 + player.size.width/2
    let leftLimit = -rightLimit
    
    if playerPosition.x < leftLimit {
      playerPosition = convert(CGPoint(x: rightLimit, y: 0.0), to: fgNode)
      player.position.x = playerPosition.x
    } else if playerPosition.x > rightLimit {
      playerPosition = convert(CGPoint(x: leftLimit, y: 0.0), to: fgNode)
      player.position.x = playerPosition.x
    }
    
    // Check player state
    if player.physicsBody!.velocity.dy == CGFloat(0.0) {
      playerState = .standing
    } else if player.physicsBody!.velocity.dy < CGFloat(0.0) {
      playerState = .falling
    }
    
    // Animate player
    if playerState == .jetting {
      if abs(player.physicsBody!.velocity.dx) > 100.0 {
        if player.physicsBody!.velocity.dx > 0 {
          runPlayerAnimation(playerAnimationSteerRight)
        } else {
          runPlayerAnimation(playerAnimationSteerLeft)
        }
      } else {
        runPlayerAnimation(playerAnimationJet)
      }
    } else if playerState == .falling {
      runPlayerAnimation(playerAnimationFall)
    }
  }
  
  func updateLevel() {
    if countOfLevelLayers >= 2 {
      endLevel()
      return
    }
    
    if camera!.position.y > (levelPositionY - size.height) {
      createForegroundOverlay()
      lastFGLayerNode.childNode(withName: "launchPlatform")?.removeFromParent()
      
      if countOfLevelLayers >= 2 && gameState == .playing  {
        lastFGLayerNode.addChild(exitDoor)
      }
    }
  }
  
  func updateCamera() {
    let playerPositionScene = convert(player.position, from: fgNode)
    let targetPositionY = playerPositionScene.y - (size.height * 0.10)
    let diff = (targetPositionY - camera!.position.y) * 0.2
    let newCameraPositionY = camera!.position.y + diff
    camera!.position.y = newCameraPositionY
  }
  
  // MARK: - Utility Methods
  func startGame() {
    gameState = .playing
  }
  
  func endLevel() {
    //gameState = .waitingForStartTap
  }
  
  func sceneCropAmount() -> CGFloat {
    let scale = view!.bounds.size.height / size.height
    let scaledWidth = size.width * scale
    let scaledOverlap = scaledWidth - view!.bounds.size.width
    return scaledOverlap / scale
  }
  
  func isNodeVisible(_ node: SKNode, positionY: CGFloat) -> Bool {
    if !camera!.contains(node) {
      if positionY < camera!.position.y - size.height * 2.0 {
        return false
      }
    }
    
    return true
  }
  
  func setPlayerVelocity(_ amount: CGFloat) {
    let gain: CGFloat = 1.5
    player.physicsBody!.velocity.dy = max(player.physicsBody!.velocity.dy, amount * gain)
  }
  
  func setupAnimationWithPrefix(_ prefix: String, start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
    var textures: [SKTexture] = []
    
    for i in start ... end {
      textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
    }
    
    return SKAction.animate(with: textures, timePerFrame: timePerFrame)
  }
  
  func runPlayerAnimation(_ animation: SKAction) {
    if animation != currentPlayerAnimation {
      player.removeAction(forKey: "playerAnimation")
      player.run(animation, withKey: "playerAnimation")
      currentPlayerAnimation = animation
    }
  }
  
  func jetBoostPlayer() {
    playerState = .jetting
    run(soundBoost)
    setPlayerVelocity(1400)
  }
}
