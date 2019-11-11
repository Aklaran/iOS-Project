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
  static let swooshFile = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  
  // Bat Constants
  static let maxZMagnitude : CGFloat = 100
  static let flapVelocityConversion : CGFloat = 1 // smaller
  
  // instance vars
  var velocity : CGFloat = -1.5
  let audioManager : AudioManager
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
  
  init(audioManager: AudioManager, pos: Int?, hide: Bool?) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat")
    self.audioManager = audioManager
    flapping = self.audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!, maxZMagnitude: Bat.maxZMagnitude)
    flapping?.isRepeated = true
    flapping?.speed = abs(velocity) / Bat.flapVelocityConversion
    z = Bat.maxZMagnitude
    flapping?.start()
    
    // init super vars
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    // randomly assign to a screen third
    var third: Int;
    print(pos)
    if pos != nil {
      third = pos!
    } else {
        third = Int.random(in: 0...2)
    }
    
    position = CGPoint(
      x: Bat.SIXTH_SCREEN_WIDTH + (2 * CGFloat(third) * Bat.SIXTH_SCREEN_WIDTH),
      y: 3 * UIScreen.main.bounds.height / 4
      //      y: Int.random(in: 0...Int(UIScreen.main.bounds.height))
    )
    
    //hide is false --> mk
    if hide != nil {
      isHidden = hide!;
    } else {
      // we should not be able to see anything by default
      isHidden = true
    }
    
    // these are not set in the first update of z because super has not been inited yet
    xScale = 0
    yScale = 0
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    flapping = nil
    audioManager = AudioManager()
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
    removeFromParent()
  }
  
  func hit() {
    isHidden = true
    // play sound to hit the player
    let hitSound = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!, maxZMagnitude: Bat.maxZMagnitude)
    hitSound.updatePosition(self.position)
    hitSound.start()
  }
  
  func pass() {
    isHidden = true
    // play whoosh sound to pass the player
    let whooshSound = audioManager.createEmitter(soundFile: Bat.swooshFile, maxZMagnitude: Bat.maxZMagnitude)
    whooshSound.updatePosition(self.position)
    whooshSound.volume = 0.3
    whooshSound.speed = 2
    whooshSound.start()
  }
  
}
