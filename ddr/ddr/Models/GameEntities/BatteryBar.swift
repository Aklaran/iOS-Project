//
//  DDR
//
//  Created by Dean Dijour on 10/25/19.
//  Copyright © 2019 Dean Dijour. All rights reserved.
//

import UIKit
import SpriteKit

class BatteryBar: SKSpriteNode {
  
  private var charge = 3;
  private var batteryTexture = SKTexture(imageNamed: "battery0")
  
  init() {
    super.init(texture: batteryTexture, color: SKColor.clear, size: batteryTexture.size())
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func increment() {
    if charge < 3 {
      charge += 1;
      self.batteryTexture = SKTexture(imageNamed: "battery\(charge)")
    }
  }
  
  func decrement() {
    if charge < 3 {
      charge += 1;
      self.batteryTexture = SKTexture(imageNamed: "battery\(charge)")
    }
  }
}
