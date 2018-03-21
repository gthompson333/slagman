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
      print("No slagmanvoice sound file.")
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
