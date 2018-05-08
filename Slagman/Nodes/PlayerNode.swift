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
  var controlEnabled = true
  private var numBoosts = 0
  
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
    if SessionData.sharedInstance.currentChallenge == 0 {
      numBoosts = 1
    } else {
      numBoosts += 1
    }
    
    if numBoosts > 3 {
      return
    }
    
    // Movement animation
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        run(actions["steeringright"]!)
      } else {
        run(actions["steeringleft"]!)
      }
    } else {
      run(actions["boost"]!)
    }
    
    // Sounds
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      switch numBoosts {
      case 1:
        run(actions["boostsound"]!)
      case 2:
        run(actions["smallboostsound"]!)
      case 3:
        run(actions["fizzleboostsound"]!)
      default:
        break
      }
    }
    
    // Boost particles
    childNode(withName: "boostparticles")?.removeFromParent()
    
    switch numBoosts {
    case 1:
      let boostParticles = SKEmitterNode(fileNamed: "boostparticles")!
      boostParticles.name = "boostparticles"
      boostParticles.particleBirthRate = 400
      boostParticles.position = CGPoint(x: boostParticles.position.x, y: boostParticles.position.y - 70)
      boostParticles.targetNode = parent
      addChild(boostParticles)
      setJumpVelocity(700)
    case 2,3:
      let boostParticles = SKEmitterNode(fileNamed: "smallboostparticles")!
      boostParticles.name = "boostparticles"
      boostParticles.particleBirthRate = 400
      boostParticles.position = CGPoint(x: boostParticles.position.x, y: boostParticles.position.y - 70)
      boostParticles.targetNode = parent
      addChild(boostParticles)
      
      if numBoosts == 2 {
        setJumpVelocity(600)
      } else {
        setJumpVelocity(400)
      }
    default:
      break
    }
    
    run(SKAction.afterDelay(0.25, runBlock: {
      if let boostParticles = self.childNode(withName: "boostparticles") as? SKEmitterNode {
        boostParticles.particleBirthRate = 0
      }
    }))
  }
  
  func powerBoost() {
    numBoosts = 0
    
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        run(actions["steeringright"]!)
      } else {
        run(actions["steeringleft"]!)
      }
    } else {
      run(actions["boost"]!)
    }
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      run(actions["powerboostsound"]!)
    }
    
    setJumpVelocity(900)
  }
  
  func transport(from node: SKSpriteNode) {
    guard let scene = scene as? GameScene else {
      return
    }
    
    if let offset = node.userData?["xoffset"] as? Int {
      physicsBody?.isDynamic = false
      let convert = node.convert(node.position, to: scene.fgNode)
      let moveActionY = SKAction.moveTo(y: convert.y, duration: 0.5)
      let moveActionX = SKAction.moveTo(x: position.x + CGFloat(offset), duration: 0.5)
      let scaleAction = SKAction.scale(to: 0.0, duration: 0.5)
      
      let soundScale = SKAction.group([actions["transportsound"]!, scaleAction])
      var sequence = SKAction.sequence([soundScale, moveActionY, moveActionX])
      
      if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == false {
        sequence = SKAction.sequence([scaleAction, moveActionY, moveActionX])
      }
      
      run(sequence) {
        self.physicsBody?.isDynamic = true
        self.run(SKAction.scale(to: 0.9, duration: 0.5))
        
        guard let transportEffect = SKEmitterNode(fileNamed: "playertransporteffect") else {
          assertionFailure("Missing playertransporteffect.sks particles file.")
          return
        }
        
        transportEffect.position = self.position
        transportEffect.targetNode = self.parent
        self.parent?.addChild(transportEffect)
        
        self.powerBoost()
      }
    }
  }
  
  func falling() {
    run(actions["falling"]!)
  }
  
  func doneDeaded() {
    guard let explode = SKEmitterNode(fileNamed: "playerdeadexplosion") else {
      assertionFailure("Missing playerdeadexplosion.sks particles file.")
      return
    }
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      parent?.run(actions["explosionsound"]!)
    }
    
    explode.position = position
    explode.targetNode = parent
    parent?.addChild(explode)
    
    self.removeFromParent()
  }
  
  // MARK: - Animations
  // Load up the movement animations collection.
  private func createActions() {
    let timePerFrame: TimeInterval = 0.1
    
    actions["boost"] = setupAnimationWithPrefix("player01_jet_", start: 1, end: 4, timePerFrame: timePerFrame)
    actions["falling"] = setupAnimationWithPrefix("player01_fall_", start: 1, end: 3, timePerFrame: timePerFrame)
    actions["steeringleft"] = setupAnimationWithPrefix("player01_steerleft_", start: 1, end: 2, timePerFrame: timePerFrame)
    actions["steeringright"] = setupAnimationWithPrefix("player01_steerright_", start: 1, end: 2, timePerFrame: timePerFrame)
    
    actions["boostsound"] = SKAction.playSoundFileNamed("boost.wav", waitForCompletion: false)
    actions["powerboostsound"] = SKAction.playSoundFileNamed("powerboost.wav", waitForCompletion: false)
    actions["smallboostsound"] = SKAction.playSoundFileNamed("boost.wav", waitForCompletion: false)
    actions["fizzleboostsound"] = SKAction.playSoundFileNamed("fizzleboost.wav", waitForCompletion: false)
    actions["explosionsound"] = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    actions["transportsound"] = SKAction.playSoundFileNamed("transport.wav", waitForCompletion: false)
  }
  
  func setupAnimationWithPrefix(_ prefix: String, start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
    var textures: [SKTexture] = []
    
    for i in start ... end {
      textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
    }
    
    return SKAction.animate(with: textures, timePerFrame: timePerFrame)
  }
}



