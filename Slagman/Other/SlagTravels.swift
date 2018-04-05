//
//  SlagAdventures.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/3/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagTravels: UITableViewController {
  let travelItems = [["name" : "Slag Travels 1", "locked" : false],
                     ["name" : "Future Slag Travels 2", "locked" : true],
                     ["name" : "Future Salg Travels 3", "locked" : true]]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  deinit {
    print("Deinit SlagTravels")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
