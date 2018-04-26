//
//  SlagTravelChallenges.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/4/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagChallengesViewController: UITableViewController {
  let travels = [[["name" : "Learn to Slag!", "locked" : false],
                    ["name" : "Let's Slag!", "locked" : false],
                    ["name" : "Link the Slag!", "locked" : false],
                    ["name" : "Power to The Slag!", "locked" : false],
                    ["name" : "Watch for Slag Mines!", "locked" : false],
                    ["name" : "Grav to The Slag!", "locked" : false],
                    ["name" : "Are You Slaggy?!", "locked" : false],
                    ["name" : "Little Grabby Slags!", "locked" : false],
                    ["name" : "Mr. Slaggy Says Hello!", "locked" : false],
                    ["name" : "Time to Slag Up!", "locked" : false],
                    ["name" : "Bust a Slag Move!", "locked" : false]],
                  [["name" : "It's a Good Day to Slag!", "locked" : false],
                   ["name" : "Slag Hard!", "locked" : false],
                   ["name" : "Git Off Your Slag!", "locked" : false],
                   ["name" : "For a Few Slag More!", "locked" : false]]]
  
  var selectedTravelsIndex = 0 {
    didSet {
      assert(selectedTravelsIndex < travels.count)
    }
  }
  
  deinit {
    print("Deinit SlagTravelChallenges")
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return travels[selectedTravelsIndex].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "challengecell", for: indexPath)
    let nameLabel = cell.viewWithTag(1) as! UILabel
    
    let item = travels[selectedTravelsIndex][indexPath.row]
    nameLabel.text = (item["name"] as! String)
    
    if (item["locked"] as! Bool) == true {
      cell.isUserInteractionEnabled = false
      nameLabel.textColor = .gray
    } else {
      cell.isUserInteractionEnabled = true
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let challengeNumber = indexPath.row + (selectedTravelsIndex * 10)
    
    if selectedTravelsIndex > 0 {
      print("Saving to session data, challenge number: \(challengeNumber + 1)")
      SessionData.sharedInstance.currentChallenge = challengeNumber + 1
    } else {
      print("Saving to session data, challenge number: \(challengeNumber)")
      SessionData.sharedInstance.currentChallenge = challengeNumber
    }
    
    SessionData.saveData()
    performSegue(withIdentifier: "segueFromChallengesToGame", sender: self)
  }
}
