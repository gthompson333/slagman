//
//  ChallengeCompleted.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class TutorialCompletedScene: SKScene {
  var completedLabel: SKLabelNode!
  var slagCreatedLabel: SKLabelNode!
  var slagTimeLabel: SKLabelNode!
  var earnedSlagLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagCreated = 0
  var slagTime = TimeInterval.leastNonzeroMagnitude
  
  var gameViewController: GameViewController?
  
  override func didMove(to view: SKView) {
    slagCreatedLabel = childNode(withName: "slagcreatedlabel") as! SKLabelNode
    slagCreatedLabel.text = "\(slagCreated) Slag Earned!"
    
    slagTimeLabel = childNode(withName: "slagtimelabel") as! SKLabelNode
    
    let timeData = SessionData.sharedInstance.recordBestTime(newTime: slagTime, challengeNumber: challengeNumberCompleted)
    slagTime = timeData.bestTime
    
    updateSlagTimeLabel()
    
    SessionData.sharedInstance.earnedSlag += slagCreated
    print("\(SessionData.sharedInstance.earnedSlag) earned slag saved to session data.")
    
    earnedSlagLabel = childNode(withName: "earnedslaglabel") as! SKLabelNode
    earnedSlagLabel.text = "\(SessionData.sharedInstance.earnedSlag) Total Game Slag"
    
    print("Saving to session data, challenge number: \(challengeNumberCompleted + 1)")
    SessionData.sharedInstance.currentChallenge = challengeNumberCompleted + 1
    SessionData.saveData()
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