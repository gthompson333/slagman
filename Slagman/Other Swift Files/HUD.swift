//
//  HUD.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

private enum HUDSettings {
  static let font = "MarkerFelt-Wide"
  static let fontSize: CGFloat = 60
  static let fontColor: UIColor = .orange
}

class HUD: SKNode {
  private var slagTimeLabel: SKLabelNode!
  private var slagLabel: SKLabelNode!
  
  var slagAmount: Int = 0 {
    didSet {
      updateSlagLabel(slag: slagAmount)
    }
  }
  
  var homeButton: SKSpriteNode!
  
  override init() {
    super.init()
    name = "HUD"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func updateSlagLabel(slag: Int) {
    if slagLabel == nil {
      createDisplay()
    }
    
    slagLabel?.text = "Slag: \(slag)"
  }
  
  func createDisplay() {
    guard let scene = scene else { return }
    
    slagLabel = SKLabelNode(fontNamed: HUDSettings.font)
    slagLabel.fontSize = HUDSettings.fontSize
    slagLabel.fontColor = HUDSettings.fontColor
    slagLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.height/2 - 80)
    slagLabel.zPosition = 5
    addChild(slagLabel)
    
    homeButton = SKSpriteNode(imageNamed: "homeicon")
    homeButton.name = "homebutton"
    homeButton.position = CGPoint(x: -490, y: scene.frame.height/2 - 90)
    homeButton.zPosition = 5
    addChild(homeButton)
  }
}
