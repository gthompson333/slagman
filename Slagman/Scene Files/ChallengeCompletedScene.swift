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
  var newTimeLabel: SKLabelNode!
  var slagCreatedLabel: SKLabelNode!
  var slagTimeLabel: SKLabelNode!
  var earnedSlagLabel: SKLabelNode!
  
  var challengeNumberCompleted = 0
  var slagCreated = 0
  var slagTime = TimeInterval.leastNonzeroMagnitude
  
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
    
    slagCreatedLabel = childNode(withName: "slagcreatedlabel") as! SKLabelNode
    slagCreatedLabel.text = "\(slagCreated) Slag Earned!"
    
    slagTimeLabel = childNode(withName: "slagtimelabel") as! SKLabelNode
    slagTimeLabel.formatText(time: slagTime)
    
    let timeData = SessionData.sharedInstance.recordBestTime(newTime: slagTime, challengeNumber: challengeNumberCompleted)
    
    newTimeLabel = childNode(withName: "newtimelabel") as! SKLabelNode
    newTimeLabel.formatText(time: timeData.bestTime)
    newTimeLabel.text = "TOP " + newTimeLabel.text!
    
    if timeData.isNewBestTime {
      pulseNewTimeLabel()
    }
    
    SessionData.sharedInstance.earnedSlag += slagCreated
    print("\(SessionData.sharedInstance.earnedSlag) earned slag saved to session data.")
    
    earnedSlagLabel = childNode(withName: "earnedslaglabel") as! SKLabelNode
    earnedSlagLabel.text = "\(SessionData.sharedInstance.earnedSlag) Total Game Slag"
    
    print("Saving to session data, challenge number: \(challengeNumberCompleted + 1)")
    SessionData.sharedInstance.currentChallenge = challengeNumberCompleted + 1
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
  
  func pulseNewTimeLabel() {
    let scalePulse = SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.5),
                                        SKAction.scale(to: 1.0, duration: 0.5)])
    
    newTimeLabel.run(SKAction.repeatForever(scalePulse))
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


