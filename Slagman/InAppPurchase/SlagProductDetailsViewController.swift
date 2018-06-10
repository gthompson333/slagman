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
  @IBOutlet weak var buyButton: UIButton!
  @IBOutlet weak var priceLabel: UILabel!
  
  var productDescription: String?
  var product: SKProduct?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = UIColor.orange
    
    guard let product = product, let name = resourceNameForProductIdentifier(product.productIdentifier) else {
      return
    }
    
    imageView?.image =  UIImage(named: name)
    
    setPurchaseState()
    productDescriptionLabel.text = productDescription
    
    NotificationCenter.default.addObserver(self, selector: #selector(SlagProductDetailsViewController.handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
  }
  
  deinit {
    print("Deinit SlagProductDetailsViewController")
  }
  
  private func setPurchaseState() {
    guard let product = product else { return }
    
    if SlagProducts.inAppHelper.isProductPurchased(product.productIdentifier) {
      priceLabel.text = "Purchased"
      buyButton.isHidden = true
    } else if IAPHelper.canMakePayments() {
      SlagProducts.priceFormatter.locale = product.priceLocale
      priceLabel.text = SlagProducts.priceFormatter.string(from: product.price)
      buyButton.isHidden = false
    } else {
      priceLabel.text = "Not Available"
      buyButton.isHidden = true
    }
  }
  
  @IBAction func buyButtonTapped(_ sender: UIButton) {
    SlagProducts.inAppHelper.buyProduct(product!)
  }
  
  @IBAction func dismissButtonTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handlePurchaseNotification(_ notification: Notification) {
    setPurchaseState()
  }
}
