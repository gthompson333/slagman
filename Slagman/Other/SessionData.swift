//
//  UserGameData.swift
//  Slagman
//
//  Created by Greg M. Thompson on 4/6/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import Foundation

class SessionData: NSObject, NSCoding {
  static let sharedInstance = SessionData.loadData()
  
  var currentChallenge = 0
  var earnedSlag = 0
  var bestTimes = Array(repeating: TimeInterval.infinity, count: 11)

  override init() {
    super.init()
    print("SessionData init")
  }
  
  required init?(coder aDecoder: NSCoder) {
    print("SessionData init coder")
    
    currentChallenge = aDecoder.decodeInteger(forKey: "currentchallenge")
    earnedSlag = aDecoder.decodeInteger(forKey: "earnedslag")
    
    if let decodedTimes = aDecoder.decodeObject(forKey: "besttimes") as? [Double] {
      bestTimes = decodedTimes
    }
  }
  
  func encode(with aCoder: NSCoder) {
    print("encoding")
    aCoder.encode(currentChallenge, forKey: "currentchallenge")
    aCoder.encode(earnedSlag, forKey: "earnedslag")
    aCoder.encode(bestTimes, forKey: "besttimes")
  }
  
  func recordBestTime(newTime: TimeInterval, challengeNumber: Int) -> (bestTime: TimeInterval, isNewBestTime: Bool) {
    var returnTime = newTime
    var isNewBestTime = false
    
    guard challengeNumber < bestTimes.count else {
      assertionFailure("User game data challenge number is out of range of best times array.")
      return (returnTime, isNewBestTime)
    }
    
    returnTime = TimeInterval.minimum(newTime, bestTimes[challengeNumber])
    bestTimes[challengeNumber] = returnTime
    
    if returnTime == newTime {
      isNewBestTime = true
    }
    
    return (returnTime, isNewBestTime)
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
