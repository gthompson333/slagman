//
//  UserGameData.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/6/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import Foundation
import GameKit

class SessionData: NSObject, NSCoding {
  static let sharedInstance = SessionData.loadData()
  
  var travels = [["name" : "The Slag Journeys", "locked" : false],
                     ["name" : "The Chronicles of Slagman", "locked" : true],
                     ["name" : "Slag Physics", "locked" : true]]
  
  var travelChallenges = [[["name" : "Learn to Slag", "locked" : false],
                  ["name" : "Let's Slag", "locked" : true],
                  ["name" : "Link The Slag", "locked" : true],
                  ["name" : "Power to The Slag", "locked" : true],
                  ["name" : "Watch for Slag Mines", "locked" : true],
                  ["name" : "Slag Gravity", "locked" : true],
                  ["name" : "Are You Feeling Slaggy?", "locked" : true],
                  ["name" : "Little Grabby Slags", "locked" : true],
                  ["name" : "Mr. Slaggy Says Hello", "locked" : true],
                  ["name" : "Time to Slag Up", "locked" : true],
                  ["name" : "Bust a Slag Move", "locked" : true]],
                 [["name" : "It's a Good Day to Slag", "locked" : true],
                  ["name" : "Slag Hard", "locked" : true],
                  ["name" : "Slag Harder", "locked" : true],
                  ["name" : "For a Few Slag More", "locked" : true],
                  ["name" : "Escape from New Slag", "locked" : true],
                  ["name" : "Slag Wars", "locked" : true],
                  ["name" : "The Good, The Bad, and The Slag", "locked" : true],
                  ["name" : "The Big Slagowski", "locked" : true],
                  ["name" : "Pulp Slag", "locked" : true],
                  ["name" : "Guardians of The Slag", "locked" : true]],
                 [["name" : "Slag Warp", "locked" : true],
                  ["name" : "Transport the Slag", "locked" : true],
                  ["name" : "The Slag Principle", "locked" : true],
                  ["name" : "The Symmetry of Slag", "locked" : true],
                  ["name" : "The Slag Paradox", "locked" : true],
                  ["name" : "Slag = MC^Slagged", "locked" : true],
                  ["name" : "The Slag Particle", "locked" : true],
                  ["name" : "The Slag Continuum", "locked" : true],
                  ["name" : "The Quantum Slag", "locked" : true],
                  ["name" : "The Theory of Slag", "locked" : true]]]
  
  var gameMode = GameMode.freestyle {
    didSet {
      if gameMode == .slagrun {
        slagrunChallenge = 1
        slagRunPoints = 0
        challengesTotallySlagged = 0
      }
    }
  }
  
  var freestyleChallenge = 0 {
    didSet {
      if freestyleChallenge > maximumFreestyleChallengeIndex {
        slagRunModeEnabled = true
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let gkachievement = GKAchievement(identifier: "theslaggraduate")
            gkachievement.percentComplete = 100.0
            gkachievement.showsCompletionBanner = true
            
            // Attempt to send the completed achievement to Game Center.
            GKAchievement.report([gkachievement]) { (error) in
              if error == nil {
                print("GameKit achievement successfully reported: \(gkachievement).")
              }
            }
        }
      }
    }
  }
  
  var slagrunChallenge = 1
  
  var slagRunPoints = 0 {
    didSet {
      if (gameMode == .slagrun) && (slagRunPoints > bestSlagRun) {
        bestSlagRun = slagRunPoints
      }
    }
  }
  var bestSlagRun = 0
  var challengesTotallySlagged = 0
  var countOfSlagrunAttempts = 0
  var slagRunModeEnabled = false
  let maximumFreestyleChallengeIndex = 30

  override init() {
    super.init()
    print("SessionData init")
  }
  
  required init?(coder aDecoder: NSCoder) {
    print("SessionData init coder")
    
    freestyleChallenge = aDecoder.decodeInteger(forKey: "freestylechallenge")
    bestSlagRun = aDecoder.decodeInteger(forKey: "bestslagrun")
    slagRunModeEnabled = aDecoder.decodeBool(forKey: "slagrunmodeenabled")
    
    if let decodedTravelChallenges = aDecoder.decodeObject(forKey: "travelchallenges") as? [[[String : Any]]] {
      travelChallenges = decodedTravelChallenges
    }
    
    if let decodedTravels = aDecoder.decodeObject(forKey: "travels") as? [[String : Any]] {
      travels = decodedTravels
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(freestyleChallenge, forKey: "freestylechallenge")
    aCoder.encode(bestSlagRun, forKey: "bestslagrun")
    aCoder.encode(travelChallenges, forKey: "travelchallenges")
    aCoder.encode(travels, forKey: "travels")
    aCoder.encode(slagRunModeEnabled, forKey: "slagrunmodeenabled")
  }
  
  class func saveData() {
    print("Saving session data.")
    
    guard let directory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else
    {
      assertionFailure("Unable to get file manager library directory.")
      return
    }
    
    let saveURL = directory.appendingPathComponent("SessionData")
    
    do {
      try FileManager.default.createDirectory(atPath: saveURL.path, withIntermediateDirectories: true,
                                              attributes: nil)
    } catch let error as NSError {
      fatalError("Failed to create directory: \(error.debugDescription)")
    }
    
    let fileURL = saveURL.appendingPathComponent("data")
    print("Saving: \(fileURL.path)")
    NSKeyedArchiver.archiveRootObject(sharedInstance, toFile: fileURL.path)
  }
  
  class func loadData() -> SessionData {
    print("Loading session data.")
    
    var sessionData: SessionData?
    
    guard let directory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
      assertionFailure("Unable to get file manager library directory.")
      return SessionData()
    }
    
    let url = directory.appendingPathComponent("SessionData/data")
    
    if FileManager.default.fileExists(atPath: url.path) {
      sessionData = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? SessionData
    }
    
    if sessionData == nil {
      print("Unable to read session data from library directory.")
      return SessionData()
    }
    
    print("Session data successfully read from library directory.")
    return sessionData!
  }
}
