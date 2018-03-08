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
        player.stand()
      case .jetting:
        break
        //player.walk()
      case .falling:
        break
        //player.climb(up: true)
      case .dead:
        break
        //player.climb(up: false)
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
  
  // Animation timing constant.
  private var animationTimePerFrame: TimeInterval = 0.2
  
  // MARK: - Methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createActions()
  }
  
  func update(_ currentTime: TimeInterval) {
    // Is Hardhat falling? Aaaarrrrrrgh!!!!
    checkIfFalling()
    
    switch movementState {
    case .standing:
      break
    case .jetting:
      break
    default:
      break
    }
  }
  
  func jet() {
  }
  
  // MARK: - Actions
  private func stand() {
    /*if hasActions() {
      removeAllActions()
    }
    
    physicsBody!.affectedByGravity = true
    self.texture = SKTexture(pixelImageNamed: "player_stand")
    physicsBody!.velocity = CGVector.zero*/
  }
  
  private func blinkPulse(color: SKColor) {
    let blink = SKAction.sequence([SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.2),
                                   SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)])
    
    let pulse = SKAction.sequence([SKAction.scale(to: 1.4, duration: 0.2),
                                   SKAction.scale(to: 1.2, duration: 0.2)])
    
    run(SKAction.repeat(SKAction.group([blink, pulse]), count: 3))
  }
  
  private func checkIfFalling() {
    if let velocity = physicsBody?.velocity {
      // if not already falling.
      if movementState != .falling {
        if velocity.dy < -800 {
          print("Player is falling with velocity: \(velocity.dy).")
          movementState = .falling
          run(actions["fallingsound"]!)
        }
      }
    }
  }
  
  // MARK: - Animations
  
  // Run a movement animation based on a Direction enum value.
  private func startMoveAnimation(direction: Direction) {
    if direction == .left {
      xScale = -abs(xScale)
    }
    
    if direction == .right {
      xScale = abs(xScale)
    }
    
    run(actions["walking"]!, withKey: ActionKeys.MoveAnimation)
  }
  
  // Maps a Direction enum value from a velocity vector.
  private func moveDirection(for directionVector: CGVector) -> Direction {
    let direction: Direction
    
    if abs(directionVector.dy) > abs(directionVector.dx) {
      direction = directionVector.dy < 0 ? .down : .up
    } else {
      direction = directionVector.dx < 0 ? .left : .right
    }
    
    return direction
  }
  
  // Load up the movement animations collection.
  private func createActions() {
    let walkingAction = SKAction.animate(with: [SKTexture(pixelImageNamed: "player_walk1"),
                                                SKTexture(pixelImageNamed: "player_walk2")], timePerFrame: animationTimePerFrame)
    
    actions["walking"] = SKAction.repeatForever(walkingAction)
    actions["walkingsound"] = SKAction.playSoundFileNamed("Walking.m4a", waitForCompletion: false)
    
    let climbingAction = SKAction.animate(with: [SKTexture(pixelImageNamed: "player_climb1"),
                                                 SKTexture(pixelImageNamed: "player_climb2")], timePerFrame: animationTimePerFrame)
    
    actions["climbing"] = SKAction.repeatForever(climbingAction)
    actions["climbingupsound"] = SKAction.playSoundFileNamed("ClimbingUp.m4a", waitForCompletion: true)
    actions["climbingdownsound"] = SKAction.playSoundFileNamed("ClimbingDown.m4a", waitForCompletion: true)
    actions["jumpingsound"] = SKAction.playSoundFileNamed("Jumping.m4a", waitForCompletion: true)
    actions["fallingsound"] = SKAction.playSoundFileNamed("Falling.m4a", waitForCompletion: false)
  }
}



