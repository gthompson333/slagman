//
//  GravityNode.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/22/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class GravityNode: SKSpriteNode {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    rotate()
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  func rotate() {
    let rotation = createAnimationActionWithFilePrefix("gravitywell", start: 1, end: 6, timePerFrame: 0.05)
    
    /*let colorPulse = SKAction.sequence([
      SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)])
    
    let scalePulse = SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.5),
                                        SKAction.scale(to: 1.0, duration: 0.5)])*/
    
    run(SKAction.repeatForever(rotation))
  }
}


