//
//  Emitter.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 11/2/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Emitter {
  
  let player : AVAudioPlayer
  var isRepeated = false
  var destination =  CGPoint(x: 0, y: 0)
  var maxZMagnitude : CGFloat
  private var x = CGFloat(0)
  private var y = CGFloat(0)
  private var z = CGFloat(0)
  
  var speed : CGFloat = 1 {
    didSet {
      player.rate = Float(speed)
    }
  }
  
  init(soundFile: String, maxZMagnitude: CGFloat) {
    self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile))
    player.enableRate = true
    self.maxZMagnitude = maxZMagnitude
  }
  
  func start() {
    if isRepeated {
      player.numberOfLoops = -1
    } else {
      player.numberOfLoops = 1
    }
    player.play()
  }
  
  func stop() {
    player.stop()
  }
  
  func updatePosition(_ cgpt: CGPoint) {
    x = cgpt.x
    y = cgpt.y
    recalibrate()
  }
  
  func updateZ(_ z: CGFloat) {
    self.z = z
    recalibrate()
  }
  
  func updateDestination(_ cgpt: CGPoint) {
    destination = cgpt
    recalibrate()
  }
  
  private func recalibrate() {
    
    // setup pan for left/right
    var dx = x - destination.x
    let sign = dx / abs(dx)
    dx = abs(dx)
    player.pan = Float(sign * sqrt(dx / UIScreen.main.bounds.width))
    
    // setup volume for z (and maybe later for y)
    let dz = abs(z) // because the listener is assument to have z = 0
    player.volume = Float((maxZMagnitude - dz) / maxZMagnitude)
    
  }
  
}
