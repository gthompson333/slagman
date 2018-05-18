//
//  HelpADudeViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 5/17/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import UnityAds

class HelpADudeViewController: UIViewController, UnityAdsDelegate {
  @IBOutlet weak var watchButton: UIButton!
  @IBOutlet weak var slagNoButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UnityAds.initialize("1797668", delegate: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func watchButtonTapped(_ sender: UIButton) {
    if UnityAds.isReady() == true {
      UnityAds.show(self, placementId: "rewardedVideo")
    }
  }
  
  @IBAction func slagNoButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "helpadudetogame", sender: self)
  }
  
  func unityAdsReady(_ placementId: String) {
    print("Unity Ads are ready.")
    watchButton.isEnabled = true
  }
  
  func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
    print("Unity Ads Error: \(error)")
  }
  
  func unityAdsDidStart(_ placementId: String) {
    print("Unity Ads starting.")
  }
  
  func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
    print("Unity Ads finished.")
    performSegue(withIdentifier: "helpadudetogame", sender: self)
  }
}
