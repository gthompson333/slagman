//
//  SlagAdventures.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/3/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit
import StoreKit

class SlagTravelsViewController: UITableViewController, SlagTravelCellDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(SlagTravelsViewController.handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  
  @objc func handlePurchaseNotification(_ notification: Notification) {
    SessionData.sharedInstance.loadInAppPurchaseState()
    tableView.reloadData()
  }
  
  deinit {
    print("Deinit SlagTravelsViewController")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destController = segue.destination as? SlagChallengesViewController {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        destController.selectedTravelsIndex = selectedIndexPath.row
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == "showtravelchallenges" {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        let item = SessionData.sharedInstance.travels[selectedIndexPath.row]
        
        if (item["locked"] as! Bool) == true {
          return false
        }
      }
    }
    return true
  }
  
  func buyButtonTapped(cell: SlagTravelCell) {
    var travelProduct: SKProduct?
    
    for product in SlagProducts.inAppHelper.products {
      if product.productIdentifier == SlagProducts.slagPhysicsChallengesProductID {
        travelProduct = product
        break
      }
    }
    
    if let travelProduct = travelProduct {
      SlagProducts.inAppHelper.buyProduct(travelProduct)
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SessionData.sharedInstance.travels.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "travelcell", for: indexPath) as! SlagTravelCell
    cell.delegate = self
    cell.travelIndex = indexPath.row
    
    return cell
  }
  
  
}
