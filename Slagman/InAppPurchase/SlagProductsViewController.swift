//
//  GregoriusViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

class SlagProductsViewController: UITableViewController {
  @IBOutlet weak var restoreBarButton: UIBarButtonItem!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showproductdetails" {
      guard let indexPath = tableView.indexPathForSelectedRow else { return }
      
      let product = SlagProducts.inAppHelper.products[(indexPath as NSIndexPath).row]
      
      if let detailViewController = segue.destination as? SlagProductDetailsViewController {
        detailViewController.product = product
        detailViewController.productDescription = SlagProducts.productDescriptions[product.productIdentifier]
      }
    }
  }
  
  @IBAction func restoreButtonTapped(_ sender: UIBarButtonItem) {
    SlagProducts.inAppHelper.restorePurchases()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(SlagProductsViewController.reload), for: .valueChanged)
    
    NotificationCenter.default.addObserver(self, selector: #selector(SlagProductDetailsViewController.handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(SlagProductsViewController.handlePurchaseRestoreNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseRestoreNotification),
                                           object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reload()
  }
  
  deinit {
    print("Deinit SlagProductsViewController")
  }
  
  @objc func reload() {
    tableView.reloadData()
    
    SlagProducts.inAppHelper.requestProducts{success, products in
      if success {
        self.tableView.reloadData()
      } else {
        let alert = UIAlertController(title: "Are You Online?", message: "Unable to load the In-App products.  Please ensure you are connected to the internet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
      
      self.refreshControl?.endRefreshing()
    }
  }
  
  @objc func handlePurchaseNotification(_ notification: Notification) {
    reload()
    SessionData.sharedInstance.loadInAppPurchaseState()
  }
  
  @objc func handlePurchaseRestoreNotification(_ notification: Notification) {
    reload()
    SessionData.sharedInstance.loadInAppPurchaseState()
  }
}

// MARK: - UITableViewDataSource
extension SlagProductsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SlagProducts.inAppHelper.products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let product = SlagProducts.inAppHelper.products[(indexPath as NSIndexPath).row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "slagproductcell", for: indexPath) as! SlagProductCell
    cell.product = product
    return cell
  }
}
