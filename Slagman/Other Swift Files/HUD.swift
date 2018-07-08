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
  private var slagRunLabel: SKLabelNode!
  private var powerNodeCountLabel: SKLabelNode!
  
  var slagAmount: Int = 0 {
    didSet {
      updateSlagLabel(slag: slagAmount)
    }
  }
  
  var powerNodeCount: (Int, Int) = (0, 0) {
    didSet {
      updatePowerNodeCountLabel(currentCount: powerNodeCount.0, totalCount: powerNodeCount.1)
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
    if slagRunLabel == nil {
      createDisplay()
    }
    
    slagRunLabel?.text = "Slag Run: \(slag)"
  }
  
  private func updatePowerNodeCountLabel(currentCount: Int, totalCount: Int) {
    powerNodeCountLabel?.text = "Power Nodes: \(currentCount) of \(totalCount)"
  }
  
  func createDisplay() {
    guard let scene = scene else { return }
    
    slagRunLabel = SKLabelNode(fontNamed: HUDSettings.font)
    slagRunLabel.fontSize = HUDSettings.fontSize
    slagRunLabel.fontColor = HUDSettings.fontColor
    slagRunLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.height/2 - 80)
    slagRunLabel.zPosition = 5
    addChild(slagRunLabel)
    
    // The accumulated slag points value is only shown in Slag Run mode.
    if SessionData.sharedInstance.gameMode == .freestyle {
      slagRunLabel.isHidden = true
    }
    
    powerNodeCountLabel = SKLabelNode(fontNamed: HUDSettings.font)
    powerNodeCountLabel.fontSize = HUDSettings.fontSize
    powerNodeCountLabel.fontColor = HUDSettings.fontColor
    powerNodeCountLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.height/2 - 80)
    powerNodeCountLabel.zPosition = 5
    addChild(powerNodeCountLabel)
    
    if SessionData.sharedInstance.gameMode == .slagrun {
      powerNodeCountLabel.isHidden = true
    }
    
    homeButton = SKSpriteNode(imageNamed: "homeicon")
    homeButton.name = "homebutton"
    homeButton.position = CGPoint(x: -460, y: scene.frame.height/2 - 90)
    homeButton.zPosition = 5
    addChild(homeButton)
  }
}
