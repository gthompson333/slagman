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
  let gamekitPlayer = GKLocalPlayer.local
  
  @IBOutlet weak var slagRunLockImage: UIImageView!
  @IBOutlet weak var gameCenterButton: UIButton!
  @IBOutlet weak var slagRunButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    SlagProducts.inAppHelper.requestProducts{success, products in
      if success {
        SessionData.sharedInstance.loadInAppPurchaseState()
        
        if SessionData.sharedInstance.slagRunModeEnabled == true {
          DispatchQueue.main.async {
            self.slagRunLockImage.isHidden = true
          }
        }
      } else {
        print("FAILED to load In-App products.")
      }
    }
    
    // iOS Game Center authentication and sign-in.
    gamekitPlayer.authenticateHandler = { (controller, error) in
      if controller != nil {
        self.show(controller!, sender: self)
      } else if self.gamekitPlayer.isAuthenticated {
        print("GameKit player successfully authenticated.")
        self.gameCenterButton.isHidden = false
        self.reconcileHighScore()
      } else {
        print("Unable to authenticate GameKit player. GameKit disabled.")
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SessionData.sharedInstance.gameMode = .freestyle
    
    if SessionData.sharedInstance.slagRunModeEnabled == true {
      slagRunLockImage.isHidden = true
    }
  }
  
  deinit {
    print("Deinit IntroductionViewController")
  }
  
  @IBAction func freeStyleButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func slagRunButtonTapped(_ sender: UIButton) {
    if SessionData.sharedInstance.slagRunModeEnabled {
      SessionData.sharedInstance.gameMode = .slagrun
      performSegue(withIdentifier: "introductiontogame", sender: self)
    } else {
      let alert = UIAlertController(title: "Are All Challenges Unlocked?", message: "This feature requires all the challenges to be unlocked.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func gameCenterButtonTapped(_ sender: UIButton) {
    let gameCenterController = GKGameCenterViewController(leaderboardID: "slagruns", playerScope: .global, timeScope: .allTime)
    gameCenterController.gameCenterDelegate = self
    show(gameCenterController, sender: self)
  }
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
    reconcileHighScore()
  }
  
  func reconcileHighScore()  {
    let leaderboard = GKLeaderboard()
    leaderboard.identifier = "slagruns"
    leaderboard.range = NSMakeRange(1, 1)
    
    leaderboard.loadScores { (scores, error) in
      if let gkHighScore = scores?[0] {
        let gkHighScoreInt = Int(gkHighScore.value)
        
        if gkHighScoreInt > SessionData.sharedInstance.bestSlagRun {
          print("Session Data best slag run updated with GameKit best score: \(gkHighScoreInt)")
          SessionData.sharedInstance.bestSlagRun = gkHighScoreInt
        } else if SessionData.sharedInstance.bestSlagRun > gkHighScoreInt {
          let gkscore = GKScore(leaderboardIdentifier: "slagruns")
          gkscore.value = Int64(SessionData.sharedInstance.bestSlagRun)
          
          // Attempt to send the best slag run score to Game Center.
          GKScore.report([gkscore]) { (error) in
            if error == nil {
              print("GameKit score updated with Session Data best slag run: \(gkscore.value)")
            }
          }
        }
      }
    }
  }
  
  @IBAction func unwindToIntroduction(sender: UIStoryboardSegue) {
  }
}
