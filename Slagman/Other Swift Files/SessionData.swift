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
                     ["name" : "Slag Physics", "locked" : true],
                     ["name" : "The Slag Recipes", "locked" : true]]
  
  var travelChallenges = [[["name" : "Learn to Slag", "locked" : false],
                  ["name" : "Let's Slag", "locked" : false],
                  ["name" : "Link The Slag", "locked" : false],
                  ["name" : "Power to The Slag", "locked" : false],
                  ["name" : "Watch for Slag Mines", "locked" : false],
                  ["name" : "Slag Gravity", "locked" : false],
                  ["name" : "Are You Feeling Slaggy?", "locked" : false],
                  ["name" : "Little Grabby Slags", "locked" : false],
                  ["name" : "Mr. Slaggy Says Hello", "locked" : false],
                  ["name" : "Time to Slag Up", "locked" : false],
                  ["name" : "Bust a Slag Move", "locked" : false]],
                 [["name" : "It's a Good Day to Slag", "locked" : false],
                  ["name" : "Slag Hard", "locked" : false],
                  ["name" : "Slag Harder", "locked" : false],
                  ["name" : "For a Few Slag More", "locked" : false],
                  ["name" : "Escape from New Slag", "locked" : false],
                  ["name" : "Slag Wars", "locked" : false],
                  ["name" : "The Good, The Bad, and The Slag", "locked" : false],
                  ["name" : "The Big Slagowski", "locked" : false],
                  ["name" : "Pulp Slag", "locked" : false],
                  ["name" : "Guardians of The Slag", "locked" : false]],
                 [["name" : "Slag Warp", "locked" : false],
                  ["name" : "Transport the Slag", "locked" : false],
                  ["name" : "The Slag Principle", "locked" : false],
                  ["name" : "The Symmetry of Slag", "locked" : false],
                  ["name" : "The Slag Paradox", "locked" : false],
                  ["name" : "Slag = MC^Slagged", "locked" : false],
                  ["name" : "The Slag Continuum", "locked" : false],
                  ["name" : "The Slag Particle", "locked" : false],
                  ["name" : "The Quantum Slag", "locked" : false],
                  ["name" : "The Theory of Slag", "locked" : false]],
                 [["name" : "Slag Burger", "locked" : false],
                  ["name" : "Slag Slaganoff", "locked" : false],
                  ["name" : "Mac and Slag", "locked" : false],
                  ["name" : "Slag Stew", "locked" : false],
                  ["name" : "Slaghetti", "locked" : false],
                  ["name" : "Slag and Beans", "locked" : false],
                  ["name" : "Prime Slag", "locked" : false],
                  ["name" : "Slag Souffle", "locked" : false],
                  ["name" : "Fried Slag", "locked" : false],
                  ["name" : "Mushy Slags", "locked" : false]
                  ]]
  
  var gameMode = GameMode.freestyle {
    didSet {
      if gameMode == .slagrun {
        slagrunChallenge = 1
        slagRunPoints = 0
        challengesTotallySlagged = 0
      }
    }
  }
  
  var freestyleChallenge = 0
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
  let slagRunModeEnabled = true
  var unityAdsOn = false

  override init() {
    super.init()
    print("SessionData init")
  }
  
  required init?(coder aDecoder: NSCoder) {
    print("SessionData init coder")
    
    freestyleChallenge = aDecoder.decodeInteger(forKey: "freestylechallenge")
    bestSlagRun = aDecoder.decodeInteger(forKey: "bestslagrun")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(freestyleChallenge, forKey: "freestylechallenge")
    aCoder.encode(bestSlagRun, forKey: "bestslagrun")
  }
  
  func loadInAppPurchaseState() {
    travels[1]["locked"] = false
    travels[2]["locked"] = false
    travels[3]["locked"] = false
    unityAdsOn = false
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
