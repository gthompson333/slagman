//
//  ChallengeCompleted.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/15/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit
import StoreKit

class ChallengeCompletedScene: SKScene {
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
    
    nodesSlagLabel = childNode(withName: "nodesslaglabel") as? SKLabelNode
    nodesSlagLabel.text = "\(countOfPowerNodes) Out of \(powerNodesTotal)"
    
    allNodesSlagLabel = childNode(withName: "allnodesslaglabel") as? SKLabelNode
    
    if countOfPowerNodes == powerNodesTotal {
      allNodesSlagLabel.text = "SUCCESS!  All Power Nodes Slagged!"
    } else {
      allNodesSlagLabel.text = "FAIL!  Not All Power Nodes Slagged!"
    }
    
    SessionData.sharedInstance.freestyleChallenge += 1
    print("Saving to session data, freestyle challenge number: \(SessionData.sharedInstance.freestyleChallenge)")
    SessionData.saveData()
    
    NotificationCenter.default.addObserver(self, selector: #selector(ChallengeCompletedScene.handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)

  }
  
  @objc func handlePurchaseNotification(_ notification: Notification) {
    SessionData.sharedInstance.loadInAppPurchaseState()
    presentNextScene()
  }
  
  deinit {
    print("Deinit ChallengeCompletedScene")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    switch SessionData.sharedInstance.freestyleChallenge {
    case 12 ... 20:
      let item = SessionData.sharedInstance.travels[1]
      
      if (item["locked"] as! Bool) == true {
        let alert = UIAlertController(title: "Show me the money!", message: "Do you wish to purchase the rest of the collection of challenges known as The Chronicles of Slagman?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yeah!", style: .default, handler: { _ in
          if SlagProducts.inAppHelper.products.count > 0 {
            var travelProduct: SKProduct?
            
            for product in SlagProducts.inAppHelper.products {
              if product.productIdentifier == SlagProducts.chroniclesSlagmanProductID {
                travelProduct = product
                break
              }
            }
            
            if let travelProduct = travelProduct {
              SlagProducts.inAppHelper.buyProduct(travelProduct)
            }
          } else {
            let alert = UIAlertController(title: "Are You Online?", message: "Unable to complete the purchase.  Please ensure you are connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.gameViewController?.present(alert, animated: true, completion: nil)
          }
        }))
        
        alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in
          SessionData.sharedInstance.freestyleChallenge -= 1
          print("Saving to session data, freestyle challenge number: \(SessionData.sharedInstance.freestyleChallenge)")
          SessionData.saveData()
          self.gameViewController?.transitionToHome()
        }))
        
        gameViewController?.present(alert, animated: true, completion: nil)
      } else {
        presentNextScene()
      }
    case 22 ... 30:
      let item = SessionData.sharedInstance.travels[2]
      
      if (item["locked"] as! Bool) == true {
        let alert = UIAlertController(title: "Show me the money!", message: "Do you wish to purchase the rest of the collection of challenges known as Slag Physics?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yeah!", style: .default, handler: { _ in
          if SlagProducts.inAppHelper.products.count > 0 {
            var travelProduct: SKProduct?
            
            for product in SlagProducts.inAppHelper.products {
              if product.productIdentifier == SlagProducts.slagPhysicsProductID {
                travelProduct = product
                break
              }
            }
            
            if let travelProduct = travelProduct {
              SlagProducts.inAppHelper.buyProduct(travelProduct)
            }
          } else {
            let alert = UIAlertController(title: "Are You Online?", message: "Unable to complete the purchase.  Please ensure you are connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.gameViewController?.present(alert, animated: true, completion: nil)
          }
        }))
        
        alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in
          SessionData.sharedInstance.freestyleChallenge -= 1
          print("Saving to session data, freestyle challenge number: \(SessionData.sharedInstance.freestyleChallenge)")
          SessionData.saveData()
          self.gameViewController?.transitionToHome()
        }))
        
        gameViewController?.present(alert, animated: true, completion: nil)
      } else {
        presentNextScene()
      }
    case 32 ... 40:
      let item = SessionData.sharedInstance.travels[3]
      
      if (item["locked"] as! Bool) == true {
        let alert = UIAlertController(title: "Show me the money!", message: "Do you wish to purchase the rest of the collection of challenges known as The Slag Recipes?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yeah!", style: .default, handler: { _ in
          if SlagProducts.inAppHelper.products.count > 0 {
            var travelProduct: SKProduct?
            
            for product in SlagProducts.inAppHelper.products {
              if product.productIdentifier == SlagProducts.slagRecipesProductID {
                travelProduct = product
                break
              }
            }
            
            if let travelProduct = travelProduct {
              SlagProducts.inAppHelper.buyProduct(travelProduct)
            }
          } else {
            let alert = UIAlertController(title: "Are You Online?", message: "Unable to complete the purchase.  Please ensure you are connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.gameViewController?.present(alert, animated: true, completion: nil)
          }
        }))
        
        alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in
          SessionData.sharedInstance.freestyleChallenge -= 1
          print("Saving to session data, freestyle challenge number: \(SessionData.sharedInstance.freestyleChallenge)")
          SessionData.saveData()
          self.gameViewController?.transitionToHome()
        }))
        
        gameViewController?.present(alert, animated: true, completion: nil)
      } else {
        presentNextScene()
      }
    default:
      presentNextScene()
    }
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
}


