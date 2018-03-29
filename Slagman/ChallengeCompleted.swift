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
  var totalSlagCreatedLabel: SKLabelNode!
  var lifetimeSlagLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagCreated = 0
  var totalSlagCreated = 0
  var lifetimeSlag = 0
  
  override func didMove(to view: SKView) {
    completedLabel = childNode(withName: "completedlabel") as! SKLabelNode
    completedLabel.text = "Conslagulations!"
    
    slagCreatedLabel = childNode(withName: "slagcreatedlabel") as! SKLabelNode
    slagCreatedLabel.text = "\(slagCreated) Slag Earned!"
    
    totalSlagCreatedLabel = childNode(withName: "totalslagcreatedlabel") as! SKLabelNode
    totalSlagCreatedLabel.text = "\(totalSlagCreated) Slag Since Last Crash!"
    
    lifetimeSlagLabel = childNode(withName: "lifetimeslaglabel") as! SKLabelNode
    lifetimeSlagLabel.text = "\(lifetimeSlag) Lifetime Slag!"
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
