//
//  BoostNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class BoostNode: SKSpriteNode {
  /*var animation = SKAction.repeatForever(createAnimationActionWithFilePrefix("boostgold", start: 1, end: 6, timePerFrame: 0.08))
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    run(animation)
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }*/
  
  func explode() {
    guard let explode = SKEmitterNode(fileNamed: "boostexplosion") else {
      assertionFailure("Missing boostexplosion.sks particles file.")
      return
    }
    
    explode.position = position
    parent?.addChild(explode)
    
    removeFromParent()
  }
  
  func createSlagNode() -> SKSpriteNode {
    let slagNode = SKSpriteNode(imageNamed: "slag")
    slagNode.position = CGPoint(x: position.x, y: position.y - 60)
    slagNode.size = size
    
    let pulsedRed = SKAction.sequence([
      SKAction.colorize(with: .orange, colorBlendFactor: 1.0, duration: 0.15),
      SKAction.wait(forDuration: 0.1),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
    slagNode.run(SKAction.repeat(pulsedRed, count: 5))

    slagNode.physicsBody = SKPhysicsBody(circleOfRadius: slagNode.size.width/2)
    slagNode.physicsBody?.isDynamic = false
    slagNode.physicsBody?.affectedByGravity = false
    slagNode.physicsBody?.categoryBitMask = PhysicsCategory.CollidableObject
    slagNode.userData = ["deadly" : true]
    return slagNode
  }
}
