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
import UnityAds

class IntroductionViewController: UIViewController, GKGameCenterControllerDelegate, UnityAdsDelegate {
  var slagmanVoiceSound: AVAudioPlayer?
  let gamekitPlayer = GKLocalPlayer.localPlayer()
  
  @IBOutlet weak var slagRunLockImage: UIImageView!
  @IBOutlet weak var gameCenterButton: UIButton!
  @IBOutlet weak var slagRunButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    SessionData.sharedInstance.loadInAppPurchaseState()
    
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
    
    let path = Bundle.main.path(forResource: "slagmanvoice.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      slagmanVoiceSound = try AVAudioPlayer(contentsOf: url)
      slagmanVoiceSound?.play()
    } catch {
      assertionFailure("Missing slagmanvoice.m4a file.")
    }
    
    UnityAds.initialize("1797668", delegate: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SessionData.sharedInstance.gameMode = .freestyle
    
    if SessionData.sharedInstance.slagRunModeEnabled == true {
      slagRunButton.isEnabled = true
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
    SessionData.sharedInstance.gameMode = .slagrun
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func gameCenterButtonTapped(_ sender: UIButton) {
    let gameCenterController = GKGameCenterViewController()
    gameCenterController.gameCenterDelegate = self
    gameCenterController.viewState = .achievements
    gameCenterController.leaderboardTimeScope = .allTime
    gameCenterController.leaderboardIdentifier = "slagruns"
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
  
  @IBAction func unwindFromSettingsToIntroduction(sender: UIStoryboardSegue) {
  }
  
  @IBAction func unwindFromGameToIntroduction(sender: UIStoryboardSegue) {
    if UnityAds.isReady() && SessionData.sharedInstance.unityAdsOn {
      UnityAds.show(self, placementId: "video")
    }
  }
  
  @IBAction func unwindToIntroduction(sender: UIStoryboardSegue) {
  }
  
  // UnityAdsDelegate
  func unityAdsReady(_ placementId: String) {
    print("Unity Ads are ready.")
  }
  
  func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
    print("Unity Ads Error: \(error)")
  }
  
  func unityAdsDidStart(_ placementId: String) {
    print("Unity Ads starting.")
  }
  
  func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
    print("Unity Ads finished.")
  }
}
