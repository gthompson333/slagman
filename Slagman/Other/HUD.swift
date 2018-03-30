//
//  HUD.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

enum HUDSettings {
  static let font = "MarkerFelt-Wide"
  static let fontSize: CGFloat = 50
  static let fontColor: UIColor = .orange
}

class HUD: SKNode {
  var slagLabel: SKLabelNode!
  var slagRunLabel: SKLabelNode!
  
  override init() {
    super.init()
    name = "HUD"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func updateSlagLabel(points: Int) {
    if slagLabel == nil {
      createPointDisplay()
    }
    
    slagLabel?.text = "Slag: \(points)"
  }
  
  func updateSlagRunLabel(points: Int) {
    if slagRunLabel == nil {
      createPointDisplay()
    }
    
    slagRunLabel?.text = "No Crash Slag Run: \(points)"
  }
  
  func createPointDisplay() {
    guard let scene = scene else { return }
    
    slagLabel = SKLabelNode(fontNamed: HUDSettings.font)
    slagLabel.name = "slaglabel"
    slagLabel.fontSize = HUDSettings.fontSize
    slagLabel.fontColor = HUDSettings.fontColor
    slagLabel.position = CGPoint(x: 530, y: scene.frame.height/2 - 150)
    slagLabel.zPosition = 5
    slagLabel.horizontalAlignmentMode = .right
    addChild(slagLabel)
    
    slagRunLabel = SKLabelNode(fontNamed: HUDSettings.font)
    slagRunLabel.name = "slagrunlabel"
    slagRunLabel.fontSize = HUDSettings.fontSize
    slagRunLabel.fontColor = HUDSettings.fontColor
    slagRunLabel.position = CGPoint(x: 530, y: scene.frame.height/2 - 80)
    slagRunLabel.zPosition = 5
    slagRunLabel.horizontalAlignmentMode = .right
    addChild(slagRunLabel)
  }
}
