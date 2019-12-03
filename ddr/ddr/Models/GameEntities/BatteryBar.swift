//
//  DDR
//
//  Created by Dean Dijour on 10/25/19.
//  Copyright © 2019 Dean Dijour. All rights reserved.
//

import UIKit
import SpriteKit

class BatteryBar: SKSpriteNode {
  
  private var maxCharge: Int
  private var currCharge: Int;
  private var batteryTexture = SKTexture(imageNamed: "battery0")
  
  init(maxCharge: Int) {
    // always initialized with full battery
    self.maxCharge = maxCharge
    self.currCharge = maxCharge
        
    super.init(texture: batteryTexture, color: SKColor.clear, size: batteryTexture.size())
    
    setTexture(to: currCharge) // set texture to show full battery
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(percentCharge: CGFloat) {
    let charge = getCharge(from: percentCharge)
    
    if charge != currCharge {
      currCharge = charge
      setTexture(to: currCharge)
    }
  }
  
  func addOne() {
    if currCharge < maxCharge {
      currCharge += 1
      setTexture(to: currCharge)
    }
  }
  
  func getCharge(from percentage: CGFloat) -> Int {
    return Int(ceil(percentage * CGFloat(maxCharge)))
  }
  
  func setTexture(to charge: Int) {
    batteryTexture = SKTexture(imageNamed: "battery\(charge)")
    self.texture = batteryTexture
  }
}
