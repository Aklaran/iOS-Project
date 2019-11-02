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
  
  // instance vars
  let flapping : Emitter?
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      flapping?.updatePosition(position)
    }
  }
  
  init(audioManager : AudioManager) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat")
    flapping = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "lab9images/beep.mp3", ofType: nil)!)
    flapping?.isRepeated = true
    flapping?.start()
    
    // init super vars
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    // update super vars
    position = CGPoint(x: 200, y: 200)
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    flapping = nil
    super.init(coder: aDecoder)
  }
  
}