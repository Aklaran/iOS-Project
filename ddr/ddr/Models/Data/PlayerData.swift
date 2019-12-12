//
//  PlayerData.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 12/2/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation

let HIGH_SCORE = "highScore"
let TRAININGS_SEEN = "trainings"

class PlayerData {
  
  private init() {}
  static let singleton = PlayerData()
  
  func getHighScore() -> Int {
    return UserDefaults.standard.integer(forKey: HIGH_SCORE)
  }
  
  func setHighScore(to value: Int) {
    UserDefaults.standard.set(value, forKey: HIGH_SCORE)
    UserDefaults.standard.synchronize()
  }
  
  func getTrainingsSeen() -> [String] {
    return UserDefaults.standard.object(forKey: TRAININGS_SEEN) as? [String] ?? [String]()
  }
  
  func addToTrainingsSeen(levelId: String) {
    var seenTrainings = getTrainingsSeen()
    
    seenTrainings.append(levelId)
    
    print(seenTrainings)
    
    UserDefaults.standard.set(seenTrainings, forKey: TRAININGS_SEEN)
    UserDefaults.standard.synchronize()
  }
}
