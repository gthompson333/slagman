//
//  SlagAdventures.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/3/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagTravelsViewController: UITableViewController {
  let travelItems = [["name" : "The Slag Journeys", "locked" : false],
                     ["name" : "The Chronicles of Slagman", "locked" : false],
                     ["name" : "Slag Physics", "locked" : false]]
  
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
    return travelItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "travelcell", for: indexPath)
    let nameLabel = cell.viewWithTag(1) as! UILabel
    
    let item = travelItems[indexPath.row]
    nameLabel.text = (item["name"] as! String)
    
    if (item["locked"] as! Bool) == true {
      cell.isUserInteractionEnabled = false
      nameLabel.textColor = .gray
    } else {
      cell.isUserInteractionEnabled = true
    }
    
    return cell
  }
}
