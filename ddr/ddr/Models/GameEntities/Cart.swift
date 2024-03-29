//
//  Player.swift
//  DDR
//
//  Created by Dean Dijour on 10/25/19.
//  Copyright © 2019 Dean Dijour. All rights reserved.
//

import UIKit
import SpriteKit

class Cart: SKSpriteNode {
  
  init() {
    let texture = SKTexture(imageNamed: "cart1")
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    animate()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // we want the player image to alternate between one with and without jet flames so it looks like it's moving
  private func animate(){
    var backgroundTextures:[SKTexture] = []
    for i in 1...3 {
      backgroundTextures.append(SKTexture(imageNamed: "cart\(i)"))
    }
    let backgroundAnimation = SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.1))
    self.run(backgroundAnimation)
  }
}
