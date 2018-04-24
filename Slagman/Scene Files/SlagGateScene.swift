//
//  SlagGateScene.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/24/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class SlagGateScene: SKScene {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let platform1 = childNode(withName: "platform1") as! SKSpriteNode
    let platform2 = childNode(withName: "platform2") as! SKSpriteNode
    let boost = childNode(withName: "boost") as! SKSpriteNode
    
    if GameScene.theme != nil && GameScene.theme! == "firestorm" {
      platform1.texture = SKTexture(imageNamed: "platformsilver")
      platform2.texture = SKTexture(imageNamed: "platformsilver")
      boost.texture = SKTexture(imageNamed: "boostsilver")
    }
  }
}
