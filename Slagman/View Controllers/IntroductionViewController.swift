//
//  IntroductionViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/21/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import AVFoundation

class IntroductionViewController: UIViewController {
  var slagmanVoiceSound: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = Bundle.main.path(forResource: "slagmanvoice.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      slagmanVoiceSound = try AVAudioPlayer(contentsOf: url)
      slagmanVoiceSound?.play()
    } catch {
      assertionFailure("Missing slagmanvoice.m4a file.")
    }
  }
  
  deinit {
    print("Deinit IntroductionViewController")
  }
  
  @IBAction func unwindFromSettingsToIntroduction(sender: UIStoryboardSegue)
  {
  }
  
  @IBAction func unwindFromGameToIntroduction(sender: UIStoryboardSegue)
  {
  }
}
