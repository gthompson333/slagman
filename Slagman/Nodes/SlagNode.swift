//
//  SlagNode.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/22/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class SlagNode: SKSpriteNode {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    if let _ = userData?["proximity"] {
      proximity()
    } else if let _ = userData?["deadly"] {
      deadly()
    }
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  func deadly() {
    removeAllActions()
    
    let colorPulse = SKAction.sequence([
      SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)])
    
    let scalePulse = SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.5),
                                        SKAction.scale(to: 1.0, duration: 0.5)])
    
    run(SKAction.repeatForever(SKAction.group([colorPulse, scalePulse])))
  }
  
  func proximity() {
    removeAllActions()
    
    let colorPulse = SKAction.sequence([
      SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.5),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)])
    
    run(SKAction.repeatForever(colorPulse))
  }
  
  func createPhysicsForProximityNode() {
    physicsBody = SKPhysicsBody(circleOfRadius: size.width)
    physicsBody?.isDynamic = false
    physicsBody?.affectedByGravity = false
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = PhysicsCategory.CollidableObject
  }
  
  func explode() {
    let explode = explosion(intensity: 1.0)
    explode.position = position
    parent?.addChild(explode)
    
    removeFromParent()
  }
  
  func explosion(intensity: CGFloat) -> SKEmitterNode {
    let emitter = SKEmitterNode()
    let particleTexture = SKTexture(imageNamed: "spark")
    
    emitter.zPosition = 2
    emitter.particleTexture = particleTexture
    emitter.particleBirthRate = 200 * intensity
    emitter.numParticlesToEmit = Int(200 * intensity)
    emitter.particleLifetime = 0.5
    emitter.emissionAngle = CGFloat(360.0).degreesToRadians()
    emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
    emitter.particleSpeed = 1000 * intensity
    emitter.particleSpeedRange = 500 * intensity
    emitter.particleAlpha = 1.0
    emitter.particleAlphaRange = 0.25
    emitter.particleScale = 1.0
    emitter.particleScaleRange = 1.0
    emitter.particleColorBlendFactor = 1
    emitter.particleBlendMode = SKBlendMode.add
    emitter.run(SKAction.removeFromParentAfterDelay(0.5))
    
    let sequence = SKKeyframeSequence(capacity: 2)
    sequence.addKeyframeValue(SKColor.green, time: 0.25)
    sequence.addKeyframeValue(SKColor.yellow, time: 0.25)
    emitter.particleColorSequence = sequence
    
    return emitter
  }
}

