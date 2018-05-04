//
//  TransportNode.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/29/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class TransportNode: SKSpriteNode {
  func explosion(intensity: CGFloat) -> SKEmitterNode {
    let emitter = SKEmitterNode()
    let particleTexture = SKTexture(imageNamed: "spark")
    
    emitter.zPosition = 2
    emitter.particleTexture = particleTexture
    emitter.particleBirthRate = 4000 * intensity
    emitter.numParticlesToEmit = Int(400 * intensity)
    emitter.particleLifetime = 2.0
    emitter.emissionAngle = CGFloat(90.0).degreesToRadians()
    emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
    emitter.particleSpeed = 600 * intensity
    emitter.particleSpeedRange = 1000 * intensity
    emitter.particleAlpha = 1.0
    emitter.particleAlphaRange = 0.25
    emitter.particleScale = 1.2
    emitter.particleScaleRange = 2.0
    emitter.particleScaleSpeed = -1.5
    emitter.particleColorBlendFactor = 1
    emitter.particleBlendMode = SKBlendMode.add
    emitter.run(SKAction.removeFromParentAfterDelay(2.0))
    
    let sequence = SKKeyframeSequence(capacity: 5)
    sequence.addKeyframeValue(SKColor.green, time: 0.10)
    sequence.addKeyframeValue(SKColor.yellow, time: 0.10)
    sequence.addKeyframeValue(SKColor.orange, time: 0.15)
    sequence.addKeyframeValue(SKColor.white, time: 0.75)
    sequence.addKeyframeValue(SKColor.black, time: 0.95)
    emitter.particleColorSequence = sequence
    
    return emitter
  }
  
  func explode() {
    guard let explode = SKEmitterNode(fileNamed: "boostexplosion") else {
      assertionFailure("Missing boostexplosion.sks particles file.")
      return
    }
    
    explode.position = position
    parent?.addChild(explode)
    
    removeFromParent()
  }
  
  func createSlagNode() -> SlagNode {
    let slagNode = SlagNode(imageNamed: "slag")
    slagNode.position = CGPoint(x: position.x, y: position.y)
    slagNode.size = size
    
    slagNode.physicsBody = SKPhysicsBody(circleOfRadius: slagNode.size.width/2)
    slagNode.physicsBody?.isDynamic = false
    slagNode.physicsBody?.affectedByGravity = false
    slagNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
    slagNode.userData = ["deadly" : true]
    slagNode.deadlyAnimation()
    
    return slagNode
  }
}

