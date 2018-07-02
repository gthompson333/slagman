//
//  GregoriusViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 2/22/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class GregoriusViewController: UIViewController {
  @IBOutlet weak var gregoriusImageView: UIImageView!
  @IBOutlet weak var slagDefinitionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let animator = UIViewPropertyAnimator(duration: 2.5, curve: .easeInOut, animations: {
      self.gregoriusImageView?.alpha = 0.0
      self.slagDefinitionLabel?.alpha = 1.0
    })
    
    animator.addCompletion { (finalPosition) in
      DispatchQueue.main.asyncAfter(deadline:.now() + 3.5, execute: {
        self.performSegue(withIdentifier:"gregoriustotapstart",sender: self)
      })
    }
    
    animator.startAnimation(afterDelay: 2.0)
  }
  
  @IBAction func exitButtonTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier:"gregoriustotapstart",sender: self)
  }
  
  deinit {
    print("Deinit GregoriusViewController")
  }
}
