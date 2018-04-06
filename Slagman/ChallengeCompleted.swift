//
//  ChallengeCompleted.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class ChallengeCompleted: SKScene {
  var completedLabel: SKLabelNode!
  var slagCreatedLabel: SKLabelNode!
  var slagTimeLabel: SKLabelNode!
  var lifetimeSlagCreatedLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagCreated = 0
  var slagTime = TimeInterval.leastNonzeroMagnitude
  var lifetimeSlag = 0
  
  var gameViewController: GameViewController?
  
  override func didMove(to view: SKView) {
    completedLabel = childNode(withName: "completedlabel") as! SKLabelNode
    completedLabel.text = "Conslagulations!"
    
    slagCreatedLabel = childNode(withName: "slagcreatedlabel") as! SKLabelNode
    slagCreatedLabel.text = "\(slagCreated) Slag Earned!"
    
    slagTimeLabel = childNode(withName: "slagtimelabel") as! SKLabelNode
    updateSlagTimeLabel()
    
    lifetimeSlagCreatedLabel = childNode(withName: "lifetimeslaglabel") as! SKLabelNode
    lifetimeSlagCreatedLabel.text = "\(lifetimeSlag) Total Lifetime Slag Earned!"
    
    print("Persisting to user defaults challenge number: \(challengeNumberCompleted + 1)")
    UserDefaults.standard.set(challengeNumberCompleted + 1, forKey: "challengenumber")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let scene = GameScene.sceneFor(challengeNumber: challengeNumberCompleted + 1) {
      scene.scaleMode = .aspectFill
      
      if gameViewController != nil {
        let gameScene = scene as! GameScene
        gameScene.gameViewController = gameViewController!
      }
      
      view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
    }
  }
  
  func updateSlagTimeLabel() {
    let minutes = UInt8(slagTime / 60.0)
    slagTime -= (TimeInterval(minutes) * 60)
    
    let seconds = UInt8(slagTime)
    slagTime -= TimeInterval(seconds)
    
    let milliseconds = UInt8(slagTime * 100)
    
    let strSeconds = String(format: "%02d", seconds)
    let strMilliseconds = String(format: "%02d", milliseconds)
    
    slagTimeLabel?.text = "Slag Time: \(strSeconds):\(strMilliseconds) seconds"
  }
}
