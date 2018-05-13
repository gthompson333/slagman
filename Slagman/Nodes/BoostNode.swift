//
//  BoostNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class BoostNode: SKSpriteNode {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    if let patrolDistance = userData?["patrols"] as? Int {
      patrolling(distance: patrolDistance)
    }
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  func patrolling(distance: Int) {
    let move = SKAction.moveBy(x: CGFloat(distance), y: 0, duration: 2.0)
    let repeatMove = SKAction.repeatForever(SKAction.sequence([move, move.reversed()]))
    run(repeatMove)
  }
  
  func finishExplosion() {
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
}
