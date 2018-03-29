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
  static let fontColor = UIColor(red: 255, green: 147, blue: 0, alpha: 0.8)
}

class HUD: SKNode {
  var pointLabel: SKLabelNode!
  
  override init() {
    super.init()
    name = "HUD"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func updatePointDisplay(points: Int) {
    if pointLabel == nil {
      createPointDisplay(points: 0)
    }
    
    pointLabel?.text = "Slag: \(points)"
  }
  
  func createPointDisplay(points: Int) {
    guard let scene = scene else { return }
    
    pointLabel = SKLabelNode(fontNamed: HUDSettings.font)
    pointLabel.name = "pointdisplay"
    pointLabel.fontSize = HUDSettings.fontSize
    pointLabel.fontColor = HUDSettings.fontColor
    pointLabel.position = CGPoint(x: 300, y: scene.frame.height/2 - 80)
    pointLabel.zPosition = 5
    addChild(pointLabel)
    updatePointDisplay(points: points)
  }
}
