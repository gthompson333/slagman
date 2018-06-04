//
//  GregoriusViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

class SlagProductsViewController: UITableViewController {
  @IBOutlet weak var restoreBarButton: UIBarButtonItem!
  
  let showDetailSegueIdentifier = "showproductdetails"
  var products = [SKProduct]()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegueIdentifier {
      guard let indexPath = tableView.indexPathForSelectedRow else { return }
      
      let product = products[(indexPath as NSIndexPath).row]
      
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reload()
  }
  
  @objc func reload() {
    products = []
    
    tableView.reloadData()
    
    SlagProducts.inAppHelper.requestProducts{success, products in
      if success {
        self.products = products!
        
        self.tableView.reloadData()
      }
      
      self.refreshControl?.endRefreshing()
    }
  }
}

// MARK: - UITableViewDataSource
extension SlagProductsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let product = products[(indexPath as NSIndexPath).row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "slagproductcell", for: indexPath) as! SlagProductCell
    cell.product = product
    return cell
  }
}
