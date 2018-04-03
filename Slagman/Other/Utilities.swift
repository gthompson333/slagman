//
//  Utilities.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 1/31/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

enum GameState {
  case starting, playing, paused, challengeEnded
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



