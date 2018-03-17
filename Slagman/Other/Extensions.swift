//
//  Extensions.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 2/1/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

extension SKTexture {
  convenience init(pixelImageNamed: String) {
    self.init(imageNamed: pixelImageNamed)
    self.filteringMode = .nearest
  }
}
