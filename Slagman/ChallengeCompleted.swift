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
  var slagsCreatedLabel: SKLabelNode!
  var totalSlagsCreatedLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagsCreated = 0
  var totalSlagsCreated = 0
  
  override func didMove(to view: SKView) {
    completedLabel = childNode(withName: "completedLabel") as! SKLabelNode
    completedLabel.text = "Slag Challenge \(challengeNumberCompleted) Completed!"
    
    slagsCreatedLabel = childNode(withName: "slagsCreatedLabel") as! SKLabelNode
    slagsCreatedLabel.text = "\(slagsCreated) Slag Points Earned!"
    
    totalSlagsCreatedLabel = childNode(withName: "totalSlagsCreatedLabel") as! SKLabelNode
    totalSlagsCreatedLabel.text = "\(totalSlagsCreated) Slag Points Since Last Crash!"
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let nextChallengeNumber = challengeNumberCompleted + 1
    
    if let scene = GameScene.sceneFor(challengeNumber: nextChallengeNumber) {
      print("Persisting to user defaults challenge number: \(nextChallengeNumber)")
      UserDefaults.standard.set(nextChallengeNumber, forKey: "challengenumber")
      
      scene.scaleMode = .aspectFill
      view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
    }
  }
}
