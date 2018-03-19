//
//  GameViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/5/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let view = self.view as! SKView? {
      let storedChallengeNumber = UserDefaults.standard.integer(forKey: "challengenumber")
      print("Challenge number \(storedChallengeNumber) retrieved from user defaults.")
      
      if let scene = GameScene.sceneFor(challengeNumber: storedChallengeNumber) {
        //if let scene = ChallengeCompleted(fileNamed: "ChallengeCompleted") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
      }
      
      view.ignoresSiblingOrder = true
      
      view.showsFPS = true
      view.showsNodeCount = true
      view.showsPhysics = false
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
