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
      let currentChallenge = SessionData.sharedInstance.currentChallenge
      print("Challenge number \(currentChallenge) retrieved from session data.")
      
      if let scene = GameScene.sceneFor(challengeNumber: currentChallenge) {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        let gameScene = scene as! GameScene
        gameScene.gameViewController = self
        
        view.presentScene(scene)
      }
      
      view.ignoresSiblingOrder = true
      view.showsFPS = false
      view.showsNodeCount = false
      view.showsPhysics = false
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    if #available(iOS 11.0, *) {
      if let window = view.window {
        view.frame = window.safeAreaLayoutGuide.layoutFrame
      }
    }
  }
  
  deinit {
    print("Deinit GameViewController")
  }
  
  func transitionToHome() {
    print("transitioning to home")
    performSegue(withIdentifier: "unwindFromGameToIntroduction", sender: self)
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
