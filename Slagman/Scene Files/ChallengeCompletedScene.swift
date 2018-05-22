//
//  ChallengeCompleted.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import UnityAds

class ChallengeCompletedScene: SKScene, UnityAdsDelegate {
  var nodesSlagLabel: SKLabelNode!
  var allNodesSlagLabel: SKLabelNode!
  
  weak var gameViewController: GameViewController?
  
  var powerNodesTotal = 0
  var countOfPowerNodes = 0
  
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
    nodesSlagLabel.text = "\(countOfPowerNodes) Out of \(powerNodesTotal)"
    
    allNodesSlagLabel = childNode(withName: "allnodesslaglabel") as! SKLabelNode
    
    if countOfPowerNodes == powerNodesTotal {
      allNodesSlagLabel.text = "SUCCESS!  All Power Nodes Slagged!"
    } else {
      allNodesSlagLabel.text = "FAIL!  Not All Power Nodes Slagged!"
    }
    
    SessionData.sharedInstance.freestyleChallenge += 1
    print("Saving to session data, freestyle challenge number: \(SessionData.sharedInstance.freestyleChallenge)")
    
    SessionData.saveData()
    
    UnityAds.initialize("1797668", delegate: self)
  }
  
  deinit {
    print("Deinit ChallengeCompletedScene")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if UnityAds.isReady() == true {
      UnityAds.show(gameViewController!, placementId: "video")
    }
    
    presentNextScene()
  }
  
  func presentNextScene() {
    if let scene = GameScene.sceneFor(challengeNumber: SessionData.sharedInstance.freestyleChallenge) {
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


