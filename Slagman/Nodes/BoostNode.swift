//
//  BoostNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class BoostNode: SKSpriteNode {
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
    slagNode.size = CGSize(width: size.width+70, height: size.height)
    slagNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: slagNode.size.width, height: slagNode.size.height-20))
    slagNode.physicsBody?.isDynamic = false
    slagNode.physicsBody?.affectedByGravity = false
    slagNode.physicsBody?.categoryBitMask = PhysicsCategory.Object
    slagNode.userData = ["deadly" : true]
    return slagNode
  }
}
