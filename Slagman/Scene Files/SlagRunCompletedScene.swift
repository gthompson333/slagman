//
//  SlagRunCompletedScene.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import GameKit

class SlagRunCompletedScene: SKScene {
  var nodesSlagLabel: SKLabelNode!
  var nodesSlagTotalLabel: SKLabelNode!
  var challengesSlagLabel: SKLabelNode!
  var challengesSlagTotalLabel: SKLabelNode!
  var slagTotalLabel: SKLabelNode!
  var bestSlagRunLabel: SKLabelNode!
  var newBestSlagRunLabel: SKLabelNode!
  
  weak var gameViewController: GameViewController?
  
  var nodesSlag: Int {
    get {
      return SessionData.sharedInstance.slagRunPoints / 10
    }
  }
  
  override func didMove(to view: SKView) {
    let backgroundMusic = userData?["backgroundmusic"] as? String
    let introVoice = userData?["introvoice"] as? String
    
    let bgMusic = backgroundMusic != nil ? backgroundMusic! : "lunarlove.wav"
    let iVoice = introVoice != nil ? introVoice! : "slagmanvoice.m4a"
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      run(SKAction.sequence([SKAction.playSoundFileNamed(iVoice, waitForCompletion: true),
                             SKAction.run {
                              if UserDefaults.standard.bool(forKey: SettingsKeys.music) == true {
                                self.playBackgroundMusic(name: bgMusic)
                              }}]))
    }
    
    nodesSlagLabel = childNode(withName: "nodesslaglabel") as! SKLabelNode
    nodesSlagLabel.text = "\(nodesSlag) Power Nodes Slagged"
    
    nodesSlagTotalLabel = childNode(withName: "nodesslagtotallabel") as! SKLabelNode
    nodesSlagTotalLabel.text = "\(nodesSlag) x 10 = \(SessionData.sharedInstance.slagRunPoints) Slag"
    
    challengesSlagLabel = childNode(withName: "challengesslaglabel") as! SKLabelNode
    challengesSlagLabel.text = "\(SessionData.sharedInstance.challengesTotallySlagged) Challenges Completedly Slagged"
    
    challengesSlagTotalLabel = childNode(withName: "challengesslagtotallabel") as! SKLabelNode
    challengesSlagTotalLabel.text = "\(SessionData.sharedInstance.challengesTotallySlagged) x 100 = \(SessionData.sharedInstance.challengesTotallySlagged * 100)"

    slagTotalLabel = childNode(withName: "slagtotallabel") as! SKLabelNode
    slagTotalLabel.text = "Slag Total: \(SessionData.sharedInstance.slagRunPoints + (SessionData.sharedInstance.challengesTotallySlagged * 100))"
    SessionData.sharedInstance.slagRunPoints = SessionData.sharedInstance.slagRunPoints + (SessionData.sharedInstance.challengesTotallySlagged * 100)

    bestSlagRunLabel = childNode(withName: "bestslagrunlabel") as! SKLabelNode
    bestSlagRunLabel.text = "Your Best Run: \(SessionData.sharedInstance.bestSlagRun)"

    newBestSlagRunLabel = childNode(withName: "newbestslagrunlabel") as! SKLabelNode
    
    if SessionData.sharedInstance.slagRunPoints == SessionData.sharedInstance.bestSlagRun {
      newBestSlagRunLabel.text = "Your Best Run Yet!"
      pulseNewBestSlagRunLabel()
    } else {
      newBestSlagRunLabel.text = "Bummer, Dude! You've Done Better"
    }
    
    SessionData.saveData()
    
    if GKLocalPlayer.localPlayer().isAuthenticated {
      let gkscore = GKScore(leaderboardIdentifier: "slagruns")
      gkscore.value = Int64(SessionData.sharedInstance.slagRunPoints)
      
      // Attempt to send the new slag run score to Game Center.
      GKScore.report([gkscore]) { (error) in
        if error == nil {
          print("GameKit score successfully reported: \(gkscore.value).")
        }
      }
      
      reportAchievement(identifier: "newbslagrunner")
      
      if SessionData.sharedInstance.slagRunPoints >= 2000 {
         reportAchievement(identifier: "slagrunner2k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 5000 {
        reportAchievement(identifier: "slagrunner5k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 10000 {
        reportAchievement(identifier: "slagrunner10k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 20000 {
        reportAchievement(identifier: "slagrunner20k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 30000 {
        reportAchievement(identifier: "slagrunner30k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 40000 {
        reportAchievement(identifier: "slagrunner40k")
      }
      
      if SessionData.sharedInstance.slagRunPoints >= 50000 {
        reportAchievement(identifier: "slagrunner50k")
      }
      
      if SessionData.sharedInstance.challengesTotallySlagged == 30 {
        let gkachievement = GKAchievement(identifier: "slagrunnergod")
        gkachievement.percentComplete = 100.0
        gkachievement.showsCompletionBanner = true
        
        // Attempt to send the completed achievement to Game Center.
        GKAchievement.report([gkachievement]) { (error) in
          if error == nil {
            print("GameKit achievement successfully reported: \(gkachievement).")
          }
        }
      }
    }
  }
  
  deinit {
    print("Deinit SlagRunCompletedScene")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // If player is in a Slag Run and died, then the Slag Run is over and player will be returned
    // back to the home view.
    if gameViewController != nil {
      gameViewController!.transitionToHome()
    }
  }
  
  private func pulseNewBestSlagRunLabel() {
    let scalePulse = SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.5),
                                        SKAction.scale(to: 1.0, duration: 0.5)])
    
    newBestSlagRunLabel.run(SKAction.repeatForever(scalePulse))
  }
  
  private func playBackgroundMusic(name: String) {
    if let _ = childNode(withName: "backgroundmusic") {
      return
    }
    
    let music = SKAudioNode(fileNamed: name)
    music.name = "backgroundmusic"
    music.autoplayLooped = true
    addChild(music)
  }
  
  private func reportAchievement(identifier: String) {
    let gkachievement = GKAchievement(identifier: identifier)
    gkachievement.percentComplete = 100.0
    gkachievement.showsCompletionBanner = true
    
    // Attempt to send the completed achievement to Game Center.
    GKAchievement.report([gkachievement]) { (error) in
      if error == nil {
        print("GameKit achievement successfully reported: \(gkachievement).")
      }
    }
  }
}


