//
//  Stars.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 12/12/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation
import SpriteKit

class Stars: SKSpriteNode {
  private var frames: [SKTexture]
  
  init() {
    let starTexture = SKTexture(imageNamed: "stars1")
    
    frames = [SKTexture]()
    for i in 1...3 {
      frames.append(SKTexture(imageNamed: "stars\(i)"))
    }
    
    super.init(texture: starTexture, color: SKColor.clear, size: starTexture.size())
    super.isHidden = true;
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }
  
  func playAnimation() {
    let show = SKAction.unhide()
    let hide = SKAction.hide()
    let animate = SKAction.repeat(SKAction.animate(with: frames, timePerFrame: 0.2), count: 2)
    
    self.run(SKAction.sequence([show, animate, hide]))
  }
}
