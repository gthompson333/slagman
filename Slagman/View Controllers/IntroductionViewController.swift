//
//  IntroductionViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/21/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class IntroductionViewController: UIViewController, GKGameCenterControllerDelegate {
  var slagmanVoiceSound: AVAudioPlayer?
  let gamekitPlayer = GKLocalPlayer.localPlayer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // iOS Game Center authentication and sign-in.
    gamekitPlayer.authenticateHandler = { (controller, error) in
      if controller != nil {
        self.show(controller!, sender: self)
      } else if self.gamekitPlayer.isAuthenticated {
        print("Player successfully authenticated.")
      } else {
        print("Disable gamecenter")
      }
    }
    
    let path = Bundle.main.path(forResource: "slagmanvoice.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      slagmanVoiceSound = try AVAudioPlayer(contentsOf: url)
      slagmanVoiceSound?.play()
    } catch {
      assertionFailure("Missing slagmanvoice.m4a file.")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SessionData.sharedInstance.gameMode = .freestyle
  }
  
  deinit {
    print("Deinit IntroductionViewController")
  }
  
  @IBAction func freeStyleButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func slagRunButtonTapped(_ sender: UIButton) {
    SessionData.sharedInstance.gameMode = .slagrun
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func gameCenterButtonTapped(_ sender: UIButton) {
    let gameCenterController = GKGameCenterViewController()
    
    gameCenterController.gameCenterDelegate = self
    gameCenterController.viewState = .leaderboards
    gameCenterController.leaderboardTimeScope = .allTime
    gameCenterController.leaderboardIdentifier = "slagruns"
    show(gameCenterController, sender: self)
  }
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func unwindFromSettingsToIntroduction(sender: UIStoryboardSegue)
  {
  }
  
  @IBAction func unwindFromGameToIntroduction(sender: UIStoryboardSegue)
  {
  }
  
  @IBAction func unwindToIntroduction(sender: UIStoryboardSegue)
  {
  }
}
