//
//  GregoriusViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 2/22/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class GregoriusViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
      self.performSegue(withIdentifier:"gregoriustotapstart",sender: self)
    })
  }
  
  deinit {
    print("Deinit GregoriusViewController")
  }
}
