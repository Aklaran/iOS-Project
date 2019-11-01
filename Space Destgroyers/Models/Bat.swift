//
//  Bat.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 10/31/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import UIKit
import SpriteKit

class Bat: SKSpriteNode {
  
  init() {
    let texture = SKTexture(imageNamed: "invader1")
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    position = CGPoint(x: 200, y: 200)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
