//
//  SlagTravelChallenges.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/4/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import UIKit

class SlagChallengesViewController: UITableViewController {
  let challenges = [["name" : "Learn to Slag!", "locked" : false],
                    ["name" : "Can You Slag?!", "locked" : false],
                    ["name" : "Git Yer Slag On!", "locked" : false],
                    ["name" : "Link the Slag!", "locked" : false],
                    ["name" : "Watch for Slag Mines!", "locked" : false],
                    ["name" : "Are You Slaggy?!", "locked" : false],
                    ["name" : "Grav to The Slag!", "locked" : false],
                    ["name" : "Little Slag Grab!", "locked" : false],
                    ["name" : "Watch for Slag Grav!", "locked" : false],
                    ["name" : "Time to Slag Up!", "locked" : false],
                    ["name" : "The Slag Wanders!", "locked" : false]]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  deinit {
    print("Deinit SlagTravelChallenges")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return challenges.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "challengecell", for: indexPath)
    let nameLabel = cell.viewWithTag(1) as! UILabel
    
    let item = challenges[indexPath.row]
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
    print("Saving to session data, challenge number: \(indexPath.row)")
    SessionData.sharedInstance.currentChallenge = indexPath.row
    SessionData.saveData()
    
    performSegue(withIdentifier: "segueFromChallengesToGame", sender: self)
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
