//
//  SlagTravelChallenges.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/4/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagChallengesViewController: UITableViewController {
  var selectedTravelsIndex = 0 {
    didSet {
      assert(selectedTravelsIndex < SessionData.sharedInstance.travelChallenges.count)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = UIColor.orange
  }
  
  deinit {
    print("Deinit SlagTravelChallenges")
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SessionData.sharedInstance.travelChallenges[selectedTravelsIndex].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "challengecell", for: indexPath)
    let nameLabel = cell.viewWithTag(1) as! UILabel
    let lockImageview = cell.viewWithTag(2) as! UIImageView
    
    let item = SessionData.sharedInstance.travelChallenges[selectedTravelsIndex][indexPath.row]
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let challengeNumber = indexPath.row + (selectedTravelsIndex * 10)
    
    if selectedTravelsIndex > 0 {
      print("Saving to session data, challenge number: \(challengeNumber + 1)")
      SessionData.sharedInstance.freestyleChallenge = challengeNumber + 1
    } else {
      print("Saving to session data, challenge number: \(challengeNumber)")
      SessionData.sharedInstance.freestyleChallenge = challengeNumber
    }
    
    SessionData.saveData()
    performSegue(withIdentifier: "segueFromChallengesToGame", sender: self)
  }
}
