//
//  TapStartViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 2/22/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class TapStartViewController: UIViewController {
  @IBAction func tapToStartTapped(_ sender: Any) {
    self.performSegue(withIdentifier:"tapstarttogame",sender: self)
  }
}
