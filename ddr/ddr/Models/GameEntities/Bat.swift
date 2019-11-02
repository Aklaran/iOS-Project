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
  static let SCREEN_HEIGHT = UIScreen.main.bounds.height
  
  // instance vars
  let flapping : Emitter?
  
  var z : CGFloat = 0
  
  var velocity : CGFloat = -1
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      flapping?.updatePosition(position)
    }
  }
  
  init(audioManager: AudioManager) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat")
    flapping = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "beep.mp3", ofType: nil)!)
    flapping?.isRepeated = true
    flapping?.start()
    
    // init super vars
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    // update super vars
       position = CGPoint(
          x: CGFloat(Int.random(in: 0...Int(UIScreen.main.bounds.width))),
          y: Bat.SCREEN_HEIGHT
    //      y: Int.random(in: 0...Int(UIScreen.main.bounds.height))
        )
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    flapping = nil
    super.init(coder: aDecoder)
  }
  
  func updatePosition() {
    z += velocity
    
    // dropping the bats FOR DEBUG ONLY SORRY MATT
    self.position.y = (z * Bat.SCREEN_HEIGHT) / 100
  }
  
}
