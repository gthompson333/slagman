//
//  HelpADudeViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 5/17/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class HelpADudeViewController: UIViewController {
  @IBOutlet weak var watchButton: UIButton!
  @IBOutlet weak var slagNoButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func watchButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "helpadudetogame", sender: self)
  }
  
  @IBAction func slagNoButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "helpadudetogame", sender: self)
  }
}
