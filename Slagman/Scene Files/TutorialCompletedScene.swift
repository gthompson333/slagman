//
//  TutorialCompletedScene.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class TutorialCompletedScene: SKScene {
  var challengeNumberCompleted = 0
  
  var gameViewController: GameViewController?
  
  override func didMove(to view: SKView) {
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
}
