//
//  GregoriusViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

class SlagProductDetailsViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var buyButton: UIButton!
  
  var productDescription: String?
  var price: String?
  var product: SKProduct?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = UIColor.orange
    
    guard let product = product, let name = resourceNameForProductIdentifier(product.productIdentifier) else {
      return
    }
    
    imageView?.image =  UIImage(named: name)
    SlagProducts.priceFormatter.locale = product.priceLocale
    price = SlagProducts.priceFormatter.string(from: product.price)
    productDescriptionLabel.text = productDescription
    priceLabel.text = price
    
    NotificationCenter.default.addObserver(self, selector: #selector(SlagProductDetailsViewController.handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
  }
  
  @IBAction func buyButtonTapped(_ sender: UIButton) {
    SlagProducts.inAppHelper.buyProduct(product!)
  }
  
  @objc func handlePurchaseNotification(_ notification: Notification) {
    print("Purchase successful!")
  }
}
