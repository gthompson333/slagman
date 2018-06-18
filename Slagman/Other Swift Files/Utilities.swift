//
//  Utilities.swift
//  Slagman
//
//  Created by Greg M. Thompson on 1/31/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

enum GameState {
  case starting, playing, paused, challengeEnded
}

// Freestyle mode is like an arcade mode. The player can select any challenge and freely attempt
// to complete the challenge. No slag points are tracked, or stored.
// Slag Run mode always starts with the first challenge. Slag points are tracked and stored until the player
// dies. If the accumulated slag points are greater than the persisted "best slag run" value, the new
// slag points value is stored as the "best slag run".
enum GameMode {
  case freestyle, slagrun
}

enum SettingsKeys {
  static let music = "musicsetting"
  static let sounds = "soundssetting"
}

struct PhysicsCategory {
  static let Player: UInt32              = 0b1      // 1
  static let Contactable: UInt32         = 0b10     // 2
  static let Collidable: UInt32          = 0b100    // 4
 }

func createAnimationActionWithFilePrefix(_ prefix: String, start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
  var textures: [SKTexture] = []
  
  for i in start ... end {
    textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
  }
  
  return SKAction.animate(with: textures, timePerFrame: timePerFrame)
}

func createSlagNode(for node: SKSpriteNode) -> SlagNode {
  let slagNode = SlagNode(imageNamed: "slag")
  slagNode.position = CGPoint(x: node.position.x, y: node.position.y)
  slagNode.size = node.size
  
  slagNode.physicsBody = SKPhysicsBody(circleOfRadius: slagNode.size.width/2)
  slagNode.physicsBody?.isDynamic = false
  slagNode.physicsBody?.affectedByGravity = false
  slagNode.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
  slagNode.userData = ["deadly" : true]
  slagNode.deadlyAnimation()
  
  return slagNode
}

extension SKLabelNode {
  func formatText(time: TimeInterval) {
    var mutableTime = time
    let minutes = UInt8(mutableTime / 60.0)
    mutableTime -= (TimeInterval(minutes) * 60)
    
    let seconds = UInt8(time)
    mutableTime -= TimeInterval(seconds)
    
    let milliseconds = UInt8(mutableTime * 100)
    
    let strSeconds = String(format: "%02d", seconds)
    let strMilliseconds = String(format: "%02d", milliseconds)
    
    text = "Slag Time: \(strSeconds):\(strMilliseconds) seconds"
  }
}

