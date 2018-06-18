//
//  GregoriusViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

class SlagProductCell: UITableViewCell {
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }
     
      nameLabel.text = product.localizedTitle
     
      if SlagProducts.inAppHelper.isProductPurchased(product.productIdentifier) {
        priceLabel.text = "Purchased"
      } else if IAPHelper.canMakePayments() {
        SlagProducts.priceFormatter.locale = product.priceLocale
        priceLabel.text = SlagProducts.priceFormatter.string(from: product.price)
      } else {
        priceLabel.text = "Not available"
      }
    }
  }
}
