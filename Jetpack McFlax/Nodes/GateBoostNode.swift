//
//  GateBoostNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class GateBoostNode: SKSpriteNode {
  func explode() {
    guard let explode = SKEmitterNode(fileNamed: "boostexplosion") else {
      assertionFailure("Missing boostexplosion.sks particles file.")
      return
    }
    
    //explode.run(SKAction.removeFromParentAfterDelay(1.0))
    explode.position = position
    parent!.addChild(explode)
    removeFromParent()
  }
}
