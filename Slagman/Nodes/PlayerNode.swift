//
//  PlayerNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/8/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
  enum PlayerState {
    case standing
    case boosting
    case falling
    case dead
    
    fileprivate func changeState(player: PlayerNode) {
      switch self {
      case .standing:
        break
      case .boosting:
        player.boosting()
        break
      case .falling:
        player.falling()
        break
      case .dead:
        player.doneDeaded()
        break
      }
      //print("Movement state is now: \(self)")
    }
  }
  
  var playerState: PlayerState = .standing {
    didSet {
      playerState.changeState(player: self)
    }
  }
  
  // MARK: - Private properties.
  // Collection of player actions, sounds, and animations.
  private var actions: [String : SKAction] = [:]
  
  private var boostParticlesTrail: SKEmitterNode!
  
  var controlEnabled = true
  
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createActions()
   }
  
  func update() {
    guard let scene = scene as? GameScene else {
      return
    }
    
    if controlEnabled == false {
      return
    }
    
    // Set velocity based on core motion
    physicsBody!.velocity.dx = scene.xAcceleration * 1000.0
    
    // Wrap player around edges of screen
    var playerPosition = scene.convert(position, from: scene.fgNode)
    let rightLimit = scene.size.width/2 - scene.sceneCropAmount()/2 + size.width/2
    let leftLimit = -rightLimit
    
    if playerPosition.x < leftLimit {
      playerPosition = scene.convert(CGPoint(x: rightLimit, y: 0.0), to: scene.fgNode)
      position.x = playerPosition.x
    } else if playerPosition.x > rightLimit {
      playerPosition = scene.convert(CGPoint(x: leftLimit, y: 0.0), to: scene.fgNode)
      position.x = playerPosition.x
    }
    
    // Check player state
    if physicsBody!.velocity.dy == CGFloat(0.0) {
      playerState = .standing
    } else if physicsBody!.velocity.dy < CGFloat(0.0) {
      playerState = .falling
    }
  }
  
  private func setJumpVelocity(_ amount: CGFloat) {
    let gain: CGFloat = 1.5
    physicsBody!.velocity.dy = max(physicsBody!.velocity.dy, amount * gain)
  }
  
  // MARK: - Actions
  func boosting() {
    if boostParticlesTrail == nil {
      boostParticlesTrail = SKEmitterNode(fileNamed: "boostparticles")!
      boostParticlesTrail.position = CGPoint(x: boostParticlesTrail.position.x, y: boostParticlesTrail.position.y - 70)
      boostParticlesTrail.targetNode = parent
      addChild(boostParticlesTrail)
    }
    
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        run(actions["steeringright"]!)
      } else {
        run(actions["steeringleft"]!)
      }
    } else {
      run(actions["jetboost"]!)
    }
    
    run(actions["jetboostsound"]!)
    setJumpVelocity(700)
    
    boostParticlesTrail.particleBirthRate = 400
    
    run(SKAction.afterDelay(0.25, runBlock: {
      self.boostParticlesTrail.particleBirthRate = 0
    }))
  }
  
  func powerBoost() {
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        run(actions["steeringright"]!)
      } else {
        run(actions["steeringleft"]!)
      }
    } else {
      run(actions["jetboost"]!)
    }
    
    run(actions["powerboostsound"]!)
    setJumpVelocity(1000)
  }
  
  func falling() {
    run(actions["falling"]!)
  }
  
  func doneDeaded() {
    guard let explode = SKEmitterNode(fileNamed: "playerdeadexplosion") else {
      assertionFailure("Missing playerdeadexplosion.sks particles file.")
      return
    }
    
    parent?.run(actions["explosionsound"]!)
    
    explode.position = position
    explode.targetNode = parent
    parent?.addChild(explode)
    
    self.removeFromParent()
  }
  
  // MARK: - Animations
  // Load up the movement animations collection.
  private func createActions() {
    let timePerFrame: TimeInterval = 0.1
    
    actions["jetboost"] = setupAnimationWithPrefix("player01_jet_", start: 1, end: 4, timePerFrame: timePerFrame)
    actions["falling"] = setupAnimationWithPrefix("player01_fall_", start: 1, end: 3, timePerFrame: timePerFrame)
    actions["steeringleft"] = setupAnimationWithPrefix("player01_steerleft_", start: 1, end: 2, timePerFrame: timePerFrame)
    actions["steeringright"] = setupAnimationWithPrefix("player01_steerright_", start: 1, end: 2, timePerFrame: timePerFrame)
    
    actions["jetboostsound"] = SKAction.playSoundFileNamed("boost.wav", waitForCompletion: false)
    actions["powerboostsound"] = SKAction.playSoundFileNamed("powerboost.wav", waitForCompletion: false)
    actions["explosionsound"] = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
  }
  
  func setupAnimationWithPrefix(_ prefix: String, start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
    var textures: [SKTexture] = []
    
    for i in start ... end {
      textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
    }
    
    return SKAction.animate(with: textures, timePerFrame: timePerFrame)
  }
}



