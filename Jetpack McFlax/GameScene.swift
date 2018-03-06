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
  case waitingForStartTap
  case playing
}

enum PlayerState {
  case idle
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
  
  var bgNodeHeight: CGFloat!
  var player: SKSpriteNode!
  
  var lastFGOverlayNode: SKSpriteNode!
  var lastFGLayerPosition = CGPoint.zero
  var lastFGLayerHeight: CGFloat = 0.0
  var levelPositionY: CGFloat = 0.0
  var numLevelUpdates = 0
  
  var gameState = GameState.waitingForStartTap
  var playerState = PlayerState.idle
  
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
    if gameState == .waitingForStartTap {
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
    
    player = worldNode.childNode(withName: "player") as! SKSpriteNode
    
    bgNode = worldNode.childNode(withName: "background")!
    bgNodeHeight = bgNode.calculateAccumulatedFrame().height
    
    fgNode = worldNode.childNode(withName: "foreground")!
    lastFGOverlayNode = fgNode.childNode(withName: "objectLayer") as! SKSpriteNode
    lastFGOverlayNode.childNode(withName: "landingPlatform")!.run(SKAction.hide())
    
    lastFGLayerPosition = lastFGOverlayNode.position
    lastFGLayerHeight = lastFGOverlayNode.size.height
    
    addChild(cameraNode)
    camera = cameraNode
  }
  
  func createForegroundOverlay() {
    let fgOverlay = fgNode.childNode(withName: "objectLayer")
    lastFGOverlayNode = fgOverlay!.copy() as! SKSpriteNode
    
    lastFGLayerPosition.y = lastFGLayerPosition.y + lastFGOverlayNode.size.height
    lastFGLayerHeight = lastFGOverlayNode.size.height
    lastFGOverlayNode.position = lastFGLayerPosition
    
    fgNode.addChild(lastFGOverlayNode)
  }
  
  func createBackgroundOverlay() {
    let backgroundOverlay = bgNode.copy() as! SKNode
    backgroundOverlay.position = CGPoint(x: 0.0, y: levelPositionY)
    bgNode.addChild(backgroundOverlay)
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
    if player.physicsBody!.velocity.dy < CGFloat(0.0) && playerState != .falling {
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
    if numLevelUpdates >= 2 {
      endLevel()
      return
    }
    
    let cameraPos = camera!.position
    
    if cameraPos.y > levelPositionY - size.height {
      createBackgroundOverlay()
      numLevelUpdates += 1
    }
    
    while lastFGLayerPosition.y < levelPositionY {
      createForegroundOverlay()
      lastFGOverlayNode.childNode(withName: "launchPlatform")?.removeFromParent()
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
    gameState = .waitingForStartTap
    lastFGOverlayNode.childNode(withName: "landingPlatform")!.run(SKAction.unhide())
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
