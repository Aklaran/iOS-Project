//
//  PlayerData.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 12/2/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation

let HIGH_SCORE = "highScore"

class PlayerData {
  
  private init() {}
  static let singleton = PlayerData()
  
  func setHighScore(to value: Int) {
    UserDefaults.standard.set(value, forKey: HIGH_SCORE)
    UserDefaults.standard.synchronize()
  }
  
  func getHighScore() -> Int {
    return UserDefaults.standard.integer(forKey: HIGH_SCORE)
  }
}
