//
//  PlayerNode.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/8/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
  // MARK: - Movement State Machine
  enum MovementState {
    case standing
    case jetting
    case falling
    case dead
    
    fileprivate func changeState(player: PlayerNode) {
      switch self {
      case .standing:
        break
      case .jetting:
        player.jetting()
        break
      case .falling:
        player.falling()
        break
      case .dead:
        break
      }
      print("Movement state is now: \(self)")
    }
  }
  
  var movementState: MovementState = .standing {
    didSet {
      movementState.changeState(player: self)
    }
  }
  
  // MARK: - Private properties.
  // Collection of player actions, sounds, and animations.
  private var actions: [String : SKAction] = [:]
  
  private var currentMovementAnimation: SKAction!
  
  // Animation timing constant.
  private var animationTimePerFrame: TimeInterval = 0.2
  
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createActions()
  }
  
  func update() {
    guard let scene = scene as? GameScene else {
      return
    }
    
    // Set velocity based on core motion
    physicsBody!.velocity.dx = scene.xAcceleration * 1000.0
    
    // Wrap player around edges of screen
    var playerPosition = convert(position, from: scene.fgNode)
    let rightLimit = scene.size.width/2 - scene.sceneCropAmount()/2 + size.width/2
    let leftLimit = -rightLimit
    
    if playerPosition.x < leftLimit {
      playerPosition = convert(CGPoint(x: rightLimit, y: 0.0), to: scene.fgNode)
      position.x = playerPosition.x
    } else if playerPosition.x > rightLimit {
      playerPosition = convert(CGPoint(x: leftLimit, y: 0.0), to: scene.fgNode)
      position.x = playerPosition.x
    }
    
    // Check player state
    if physicsBody!.velocity.dy == CGFloat(0.0) {
      movementState = .standing
    } else if physicsBody!.velocity.dy < CGFloat(0.0) {
      movementState = .falling
    }
  }
  
  func setPlayerVelocity(_ amount: CGFloat) {
    let gain: CGFloat = 1.5
    physicsBody!.velocity.dy = max(physicsBody!.velocity.dy, amount * gain)
  }
  
  // MARK: - Actions
  func jetting() {
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        runPlayerAnimation(actions["steeringRight"]!)
      } else {
        runPlayerAnimation(actions["steeringLeft"]!)
      }
    } else {
      runPlayerAnimation(actions["jetting"]!)
    }
    
    run(actions["jettingSound"]!)
    setPlayerVelocity(700)
  }
  
  func powerJet() {
    if abs(physicsBody!.velocity.dx) > 100.0 {
      if physicsBody!.velocity.dx > 0 {
        runPlayerAnimation(actions["steeringRight"]!)
      } else {
        runPlayerAnimation(actions["steeringLeft"]!)
      }
    } else {
      runPlayerAnimation(actions["jetting"]!)
    }
    
    run(actions["jettingSound"]!)
    setPlayerVelocity(1000)
  }
  
  func falling() {
    runPlayerAnimation(actions["falling"]!)
  }
  
  private func blinkPulse(color: SKColor) {
    let blink = SKAction.sequence([SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.2),
                                   SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)])
    
    let pulse = SKAction.sequence([SKAction.scale(to: 1.4, duration: 0.2),
                                   SKAction.scale(to: 1.2, duration: 0.2)])
    
    run(SKAction.repeat(SKAction.group([blink, pulse]), count: 3))
  }
  
  // MARK: - Animations
  func runPlayerAnimation(_ animation: SKAction) {
    if animation != currentMovementAnimation {
      removeAction(forKey: "playerAnimation")
      run(animation, withKey: "playerAnimation")
      currentMovementAnimation = animation
    }
  }
  
  // Load up the movement animations collection.
  private func createActions() {
    actions["jetting"] = setupAnimationWithPrefix("player01_jet_", start: 1, end: 4, timePerFrame: 0.1)
    actions["jettingSound"] = SKAction.playSoundFileNamed("boost.wav", waitForCompletion: false)

    actions["falling"] = setupAnimationWithPrefix("player01_fall_", start: 1, end: 3, timePerFrame: 0.1)
    actions["steeringLeft"] = setupAnimationWithPrefix("player01_steerleft_", start: 1, end: 2, timePerFrame: 0.1)
    actions["steeringRight"] = setupAnimationWithPrefix("player01_steerright_", start: 1, end: 2, timePerFrame: 0.1)
  }
  
  func setupAnimationWithPrefix(_ prefix: String, start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
    var textures: [SKTexture] = []
    
    for i in start ... end {
      textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
    }
    
    return SKAction.animate(with: textures, timePerFrame: timePerFrame)
  }
}



