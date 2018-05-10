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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SessionData.sharedInstance.gameMode = .freestyle
  }
  
  deinit {
    print("Deinit IntroductionViewController")
  }
  
  @IBAction func freeStyleButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func slagRunButtonTapped(_ sender: UIButton) {
    SessionData.sharedInstance.gameMode = .slagrun
    performSegue(withIdentifier: "introductiontogame", sender: self)
  }
  
  @IBAction func unwindFromSettingsToIntroduction(sender: UIStoryboardSegue)
  {
  }
  
  @IBAction func unwindFromGameToIntroduction(sender: UIStoryboardSegue)
  {
  }
}
