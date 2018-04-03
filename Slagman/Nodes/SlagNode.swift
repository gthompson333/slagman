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
    
    if userData?["proximity"] != nil {
      proximity()
    }
    
    if userData?["deadly"] != nil {
      deadly()
    }
    
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
  
  func deadly() {
    let colorPulse = SKAction.sequence([
      SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)])
    
    let scalePulse = SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.5),
                                        SKAction.scale(to: 1.0, duration: 0.5)])
    
    run(SKAction.repeatForever(SKAction.group([colorPulse, scalePulse])))
  }
  
  func proximity() {
    let colorPulse = SKAction.sequence([
      SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.5),
      SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)])
    
    run(SKAction.repeatForever(colorPulse))
  }
  
  func createPhysicsForProximitySlag() {
    physicsBody = SKPhysicsBody(circleOfRadius: size.width)
    physicsBody?.isDynamic = false
    physicsBody?.affectedByGravity = false
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = PhysicsCategory.Contactable
    
    let turbulenceNode = SKFieldNode.turbulenceField(withSmoothness: 1.0, animationSpeed: 1.0)
    turbulenceNode.name = "turbulence"
    turbulenceNode.categoryBitMask = 1
    turbulenceNode.isEnabled = false
    addChild(turbulenceNode)
  }
  
  func contactWithProximitySlag(player: PlayerNode) {
    let turbulenceNode = childNode(withName: "turbulence") as? SKFieldNode
    
    if turbulenceNode?.isEnabled == true {
      return
    } else {
      turbulenceNode?.isEnabled = true
    }
    
    player.controlEnabled = false
    
    guard let explode = SKEmitterNode(fileNamed: "proximityexplosion") else {
      assertionFailure("Missing proximityexplosion.sks particles file.")
      return
    }
    
    explode.position = position
    parent?.addChild(explode)
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      parent?.run(SKAction.playSoundFileNamed("proximity.wav", waitForCompletion: false))
    }
    
    run(SKAction.afterDelay(0.5, runBlock: {
      player.controlEnabled = true
      self.removeFromParent()
    }))
  }
}

