//
//  SettingsViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/2/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import GameKit

class SettingsViewController: UIViewController {
  class func initializeSettings() {
    if UserDefaults.standard.object(forKey: SettingsKeys.sounds) == nil {
      UserDefaults.standard.set(true, forKey: SettingsKeys.sounds)
    }
  }
  
  @IBOutlet weak var soundsSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      soundsSwitch.isOn = true
    } else {
      soundsSwitch.isOn = false
    }
  }
  
  deinit {
    print("Deinit SettingsViewController")
  }
  
  @IBAction func soundsSwitchTapped(_ sender: UISwitch) {
    if sender.isOn {
      UserDefaults.standard.set(true, forKey: SettingsKeys.sounds)
    } else {
      UserDefaults.standard.set(false, forKey: SettingsKeys.sounds)
    }
  }
  
  @IBAction func resetButtonTapped(_ sender: UIButton) {
    let alert = UIAlertController(title: "Reset to Slag Noob?", message: "Everything resets to zero.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Slag Yeah!", style: .default, handler: { _ in
      print("Saving to session data, challenge number 1.")
      SessionData.sharedInstance.freestyleChallenge = 0
      
      print("Saving to session data, current slag run: 0.")
      SessionData.sharedInstance.slagRunPoints = 0
      
      print("Saving to session data, best slag run: 0.")
      SessionData.sharedInstance.bestSlagRun = 0
      
      SessionData.saveData()
      
      if GKLocalPlayer.local.isAuthenticated {
        GKAchievement.resetAchievements(completionHandler: { (error) in
          if error == nil {
            print("GameKit achievements successfully reset.")
          }
        })
      }
      
      self.performSegue(withIdentifier: "settingstointroduction", sender: self)
    }))
    
    alert.addAction(UIAlertAction(title: "Slag No!", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
