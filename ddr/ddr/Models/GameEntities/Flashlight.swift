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
  // UI representation of charge left
  let batteryIndicator : BatteryBar?
  
  let maxBattery : CGFloat
  
  // lower value = brighter light
  let maxBrightness : CGFloat
  
  var batteryLife : CGFloat {
    didSet {
      // apparently you can do CGFloat division by 0...
      super.falloff = maxBrightness + (1 / batteryLife)
      
      batteryIndicator?.update(percentCharge: batteryLife / maxBattery)
    }
  }
  
  init(battery: BatteryBar? = nil, maxBattery: CGFloat, brightness: CGFloat) {
    self.batteryIndicator = battery
    
    self.maxBattery = maxBattery
    self.batteryLife = maxBattery
    
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
