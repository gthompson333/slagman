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
