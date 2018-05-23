//
//  SlagAdventures.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/3/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagTravelsViewController: UITableViewController {
  deinit {
    print("Deinit SlagTravels")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destController = segue.destination as? SlagChallengesViewController {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        destController.selectedTravelsIndex = selectedIndexPath.row
      }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "travelcell", for: indexPath)
    let nameLabel = cell.viewWithTag(1) as! UILabel
    let lockImageview = cell.viewWithTag(2) as! UIImageView
    
    let item = SessionData.sharedInstance.travels[indexPath.row]
    nameLabel.text = (item["name"] as! String)
    
    if (item["locked"] as! Bool) == true {
      cell.isUserInteractionEnabled = false
      lockImageview.isHidden = false
    } else {
      cell.isUserInteractionEnabled = true
      lockImageview.isHidden = true
    }
    
    return cell
  }
}
