//
//  SlagRunCompletedScene.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class SlagRunCompletedScene: SKScene {
  var completedLabel: SKLabelNode!
  var slagLabel: SKLabelNode!
  var bestSlagRunLabel: SKLabelNode!
  weak var gameViewController: GameViewController?
  
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
    
    slagLabel = childNode(withName: "slaglabel") as! SKLabelNode
    slagLabel.text = "Current Slag Run: \(SessionData.sharedInstance.slagRun)"
    
    bestSlagRunLabel = childNode(withName: "bestslagrunlabel") as! SKLabelNode
    bestSlagRunLabel.text = "Best Slag Run: \(SessionData.sharedInstance.bestSlagRun)"

    SessionData.saveData()
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
  
  func playBackgroundMusic(name: String) {
    if let _ = childNode(withName: "backgroundmusic") {
      return
    }
    
    let music = SKAudioNode(fileNamed: name)
    music.name = "backgroundmusic"
    music.autoplayLooped = true
    addChild(music)
  }
}


