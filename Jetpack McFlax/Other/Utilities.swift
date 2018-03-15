//
//  Utilities.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 1/31/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

enum GameState {
  case starting, playing
}

/*enum ActionKeys {
  static let MoveAnimation = "moveAnimation"
}*/

struct PhysicsCategory {
  static let Player: UInt32            = 0b1      // 1
  static let JetBoost: UInt32          = 0b10     // 2
  static let Object: UInt32            = 0b100    // 4
  static let Edges: UInt32             = 0b1000   // 8
}





