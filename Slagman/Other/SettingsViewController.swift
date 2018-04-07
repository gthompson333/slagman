//
//  SettingsViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/2/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  class func initializeSettings() {
    if UserDefaults.standard.object(forKey: SettingsKeys.music) == nil {
      UserDefaults.standard.set(true, forKey: SettingsKeys.music)
    }
    
    if UserDefaults.standard.object(forKey: SettingsKeys.sounds) == nil {
      UserDefaults.standard.set(true, forKey: SettingsKeys.sounds)
    }
  }
  
  @IBOutlet weak var musicSwitch: UISwitch!
  @IBOutlet weak var soundsSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.music) == true {
      musicSwitch.isOn = true
    } else {
      musicSwitch.isOn = false
    }
    
    if UserDefaults.standard.bool(forKey: SettingsKeys.sounds) == true {
      soundsSwitch.isOn = true
    } else {
      soundsSwitch.isOn = false
    }
  }
  
  deinit {
    print("Deinit SettingsViewController")
  }
  
  @IBAction func musicSwitchTapped(_ sender: UISwitch) {
    if sender.isOn {
      UserDefaults.standard.set(true, forKey: SettingsKeys.music)
    } else {
      UserDefaults.standard.set(false, forKey: SettingsKeys.music)
    }
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
      SessionData.sharedInstance.currentChallenge = 1
      
      print("Saving to session data, 0 total game slag.")
      SessionData.sharedInstance.earnedSlag = 0
      SessionData.saveData()
    }))
    
    alert.addAction(UIAlertAction(title: "Slag No!", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
