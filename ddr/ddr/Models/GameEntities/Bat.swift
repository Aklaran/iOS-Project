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
  static let SIXTH_SCREEN_WIDTH = UIScreen.main.bounds.width / 6
  
  // Bat Constants
  static let maxZMagnitude : CGFloat = 100
  static let flapVelocityConversion : CGFloat = 6 // bigger is faster
  
  // instance vars
  var velocity : CGFloat = -1
  let flapping : Emitter?
  
  var z : CGFloat {
    didSet {
      // update sound
      flapping?.updateZ(z)
      
      // update visual
      xScale = (Bat.maxZMagnitude - abs(z)) / Bat.maxZMagnitude
      yScale = xScale
    }
  }
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      flapping?.updatePosition(position)
    }
  }
  
  init(audioManager: AudioManager) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat")
    flapping = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!, maxZMagnitude: Bat.maxZMagnitude)
    flapping?.isRepeated = true
    flapping?.speed = Bat.flapVelocityConversion / abs(velocity)
    z = Bat.maxZMagnitude
    flapping?.start()
    
    // init super vars
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    // randomly assign to a screen third
    let third = Int.random(in: 0...2)
    
    position = CGPoint(
      x: Bat.SIXTH_SCREEN_WIDTH + (2 * CGFloat(third) * Bat.SIXTH_SCREEN_WIDTH),
      y: 3 * UIScreen.main.bounds.height / 4
      //      y: Int.random(in: 0...Int(UIScreen.main.bounds.height))
    )
    
    // these are not set in the first update of z because super has not been inited yet
    xScale = 0
    yScale = 0
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    flapping = nil
    z = Bat.maxZMagnitude
    super.init(coder: aDecoder)
  }
  
  func move() {
    z += velocity
  }
  
  func isGone() -> Bool {
    return abs(z) >= Bat.maxZMagnitude
  }
  
  func die() {
    flapping?.stop()
  }
  
}
