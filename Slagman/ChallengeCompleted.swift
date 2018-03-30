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
  var slagRunLabel: SKLabelNode!
  var lifetimeSlagCreatedLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagCreated = 0
  var totalSlagCreated = 0
  var lifetimeSlag = 0
  
  override func didMove(to view: SKView) {
    completedLabel = childNode(withName: "completedlabel") as! SKLabelNode
    completedLabel.text = "Conslagulations!"
    
    slagCreatedLabel = childNode(withName: "slagcreatedlabel") as! SKLabelNode
    slagCreatedLabel.text = "\(slagCreated) Slag Earned!"
    
    slagRunLabel = childNode(withName: "totalslagcreatedlabel") as! SKLabelNode
    slagRunLabel.text = "\(totalSlagCreated) No Crash Slag Run!"
    
    lifetimeSlagCreatedLabel = childNode(withName: "lifetimeslaglabel") as! SKLabelNode
    lifetimeSlagCreatedLabel.text = "\(lifetimeSlag) Total Lifetime Slag Earned!"
    
    print("Persisting to user defaults challenge number: \(challengeNumberCompleted + 1)")
    UserDefaults.standard.set(challengeNumberCompleted + 1, forKey: "challengenumber")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let scene = GameScene.sceneFor(challengeNumber: challengeNumberCompleted + 1) {
      scene.scaleMode = .aspectFill
      view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
    }
  }
}
