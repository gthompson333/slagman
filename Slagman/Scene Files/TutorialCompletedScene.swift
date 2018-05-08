//
//  ChallengeCompleted.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class TutorialCompletedScene: SKScene {
  var currentSlagRunLabel: SKLabelNode!
  var bestSlagRunLabel: SKLabelNode!
  var gameViewController: GameViewController?
  
  override func didMove(to view: SKView) {
    currentSlagRunLabel = childNode(withName: "currentslagrunlabel") as! SKLabelNode
    currentSlagRunLabel.text = "Current Slag Run: \(SessionData.sharedInstance.currentSlagRun)"
    
    bestSlagRunLabel = childNode(withName: "bestslagrunlabel") as! SKLabelNode
    bestSlagRunLabel.text = "Best Slag Run: \(SessionData.sharedInstance.bestSlagRun)"
    
    SessionData.sharedInstance.currentChallenge += 1
    print("Saving to session data, challenge number: \(SessionData.sharedInstance.currentChallenge)")
    
    SessionData.saveData()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let scene = GameScene.sceneFor(challengeNumber: SessionData.sharedInstance.currentChallenge) {
      scene.scaleMode = .aspectFill
      
      if gameViewController != nil {
        let gameScene = scene as! GameScene
        gameScene.gameViewController = gameViewController!
      }
      
      view!.presentScene(scene, transition: SKTransition.doorway(withDuration:1))
    }
  }
}
