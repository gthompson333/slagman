//
//  ChallengeCompleted.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class ChallengeCompletedScene: SKScene {
  var completedLabel: SKLabelNode!
  var currentSlagRunLabel: SKLabelNode!
  var bestSlagRunLabel: SKLabelNode!
  var gameViewController: GameViewController?
  
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


