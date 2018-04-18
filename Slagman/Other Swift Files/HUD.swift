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
  var homeButton: SKSpriteNode!
  
  override init() {
    super.init()
    name = "HUD"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func updateSlagTimeLabel(time: TimeInterval) {
    if slagTimeLabel == nil {
      createDisplay()
    }
    
    var incomingTime = time

    let minutes = UInt8(incomingTime / 60.0)
    incomingTime -= (TimeInterval(minutes) * 60)
    
    let seconds = UInt8(incomingTime)
    incomingTime -= TimeInterval(seconds)
    
    let milliseconds = UInt8(incomingTime * 100)
    
    let strSeconds = String(format: "%02d", seconds)
    let strMilliseconds = String(format: "%02d", milliseconds)
    
    slagTimeLabel?.text = "Slag Time: \(strSeconds):\(strMilliseconds) seconds"
  }
  
  func createDisplay() {
    guard let scene = scene else { return }
    
    slagTimeLabel = SKLabelNode(fontNamed: HUDSettings.font)
    slagTimeLabel.fontSize = HUDSettings.fontSize
    slagTimeLabel.fontColor = HUDSettings.fontColor
    slagTimeLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.height/2 - 80)
    slagTimeLabel.zPosition = 5
    addChild(slagTimeLabel)
    
    homeButton = SKSpriteNode(imageNamed: "homeicon")
    homeButton.name = "homebutton"
    homeButton.position = CGPoint(x: -490, y: scene.frame.height/2 - 90)
    homeButton.zPosition = 5
    addChild(homeButton)
  }
}
