//
//  BoostNode.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class BoostNode: SKSpriteNode {
  var originalPosition: CGPoint!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    originalPosition = position
    
    if let patrolDistance = userData?["patrols"] as? Int {
      patrolling(distance: patrolDistance)
    }
    
    if let distance = userData?["wanders"] as? Int {
      wandering(distance: distance)
    }
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  private func patrolling(distance: Int) {
    let move = SKAction.moveBy(x: CGFloat(distance), y: 0, duration: 2.0)
    let repeatMove = SKAction.repeatForever(SKAction.sequence([move, move.reversed()]))
    run(repeatMove)
  }
  
  private func wandering(distance: Int) {
    let move1 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(distance), y: originalPosition.y + CGFloat(distance)), duration: 1.5)
    let move2 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(2*distance), y: originalPosition.y), duration: 1.5)
    let move3 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(distance), y: originalPosition.y - CGFloat(distance)), duration: 1.5)
    let move4 = SKAction.move(to: CGPoint(x: originalPosition.x, y: originalPosition.y), duration: 1.5)
    
    let repeatMove = SKAction.repeatForever(SKAction.sequence([move1, move2, move3, move4]))
    run(repeatMove)
  }
  
  private func explosion(intensity: CGFloat) -> SKEmitterNode {
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
  
  func finishExplosion() {
    let explode = explosion(intensity: 1.0)
    explode.position = position
    parent?.addChild(explode)
    removeFromParent()
  }
  
  func applyEffects() {
    var explode: SKEmitterNode? = nil
    
    // A finish gate power node.
    if userData?["finish"] != nil {
      explode = explosion(intensity: 1.0)
    }
    // Regular power node.
    else {
      if userData?["blockgate"] != nil {
        if let parentNode = parent {
          for child in parentNode.children {
            if child.userData?["gravity"] != nil {
              if let physics = child.physicsBody {
                physics.isDynamic = true
                physics.affectedByGravity = true
              }
            }
          }
        }
        
        guard let emitterNode = SKEmitterNode(fileNamed: "crumbleexplosion") else {
          assertionFailure("Missing crumbleexplosion.sks particles file.")
          return
        }
        explode = emitterNode
      } else {
        guard let emitterNode = SKEmitterNode(fileNamed: "boostexplosion") else {
          assertionFailure("Missing boostexplosion.sks particles file.")
          return
        }
        explode = emitterNode
      }
    } // Regular power node.
    
    if explode != nil {
      explode!.position = position
      parent?.addChild(explode!)
      removeFromParent()
    }
  }
}
