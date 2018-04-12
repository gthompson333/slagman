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

