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
// dies.
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
