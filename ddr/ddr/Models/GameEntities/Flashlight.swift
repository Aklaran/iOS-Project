//
//  Light.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 11/23/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation
import SpriteKit

class Flashlight: SKLightNode {
  let maxBattery : CGFloat
  
  // lower value = brighter light
  let maxBrightness : CGFloat
  
  var batteryLife : CGFloat {
    didSet {
      // apparently you can do CGFloat division by 0...
      super.falloff = maxBrightness + (1 / batteryLife)
    }
  }
  
  init(battery: CGFloat, brightness: CGFloat) {
    self.maxBattery = battery
    self.batteryLife = battery
    
    self.maxBrightness = brightness
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }
  
  func drainBattery(amount: CGFloat) {
    batteryLife = batteryLife > 0 ? batteryLife - amount : 0
  }
}
