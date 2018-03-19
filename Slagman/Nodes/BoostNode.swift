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
    slagNode.physicsBody = SKPhysicsBody(circleOfRadius: slagNode.size.width/2)
    slagNode.physicsBody?.isDynamic = false
    slagNode.physicsBody?.affectedByGravity = false
    slagNode.physicsBody?.categoryBitMask = PhysicsCategory.CollidableObject
    slagNode.userData = ["deadly" : true]
    return slagNode
  }
}
