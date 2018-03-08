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
  var worldNode: SKNode!
  var bgNode: SKNode!
  var fgNode: SKNode!
  var skyNode: SKNode!
  var exitDoor: SKNode!
  
  var bgNodeHeight: CGFloat!
  var player: PlayerNode!
  
  var lastFGLayerNode: SKSpriteNode!
  var lastFGLayerPosition = CGPoint.zero
  var levelPositionY: CGFloat = 0.0
  var countOfLevelLayers = 1
  
  var gameState = GameState.starting
  
  let motionManager = CMMotionManager()
  var xAcceleration = CGFloat(0)
  
  let cameraNode = SKCameraNode()
  
  // MARK: - SpriteKit Methods
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    setupCoreMotion()
    setupNodes()
  }
  
  override func update(_ currentTime: TimeInterval) {
    if gameState == .playing {
      player.update()
      updateCamera()
      updateLevel()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameState == .starting {
      startGame()
    }
    
    player.movementState = .jetting
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PhysicsCategory.JetBoost:
      player.movementState = .jetting
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
    worldNode = childNode(withName: "world")

    bgNode = worldNode.childNode(withName: "background")
    bgNodeHeight = bgNode.calculateAccumulatedFrame().height
    
    fgNode = worldNode.childNode(withName: "foreground")
    lastFGLayerNode = fgNode.childNode(withName: "objectLayer") as! SKSpriteNode
    player = fgNode.childNode(withName: "player") as! PlayerNode
    
    exitDoor = lastFGLayerNode.childNode(withName: "exitDoor")
    exitDoor.removeFromParent()
    
    skyNode = worldNode.childNode(withName: "sky")
    skyNode.removeFromParent()
    
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
        skyNode.position = CGPoint(x: skyNode.position.x, y: levelPositionY + lastFGLayerNode.size.height)
        worldNode.addChild(skyNode)
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
}
