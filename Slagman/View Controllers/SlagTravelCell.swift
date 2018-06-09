//
//  SlagTravelCell.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

protocol SlagTravelCellDelegate {
  func buyButtonTapped(cell: SlagTravelCell)
}

class SlagTravelCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lockImageView: UIImageView!
  @IBOutlet weak var buyButton: UIButton!
  
  var delegate: SlagTravelCellDelegate?
  
  var travelIndex: Int? {
    didSet {
      guard let travelIndex = travelIndex else { return }
      
      let item = SessionData.sharedInstance.travels[travelIndex]
      nameLabel.text = (item["name"] as! String)
      
      if (item["locked"] as! Bool) == true {
        lockImageView.isHidden = false
        buyButton.isHidden = false
      } else {
        lockImageView.isHidden = true
        buyButton.isHidden = true
      }
    }
  }
  
  @IBAction func buyButtonTapped(_ sender: UIButton) {
    delegate?.buyButtonTapped(cell: self)
  }
}
