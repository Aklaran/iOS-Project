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
  private var x = CGFloat(0)
  private var y = CGFloat(0)
  private var z = CGFloat(0)
  
  init(soundFile: String) {
    self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile))
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
    var distance = x - destination.x
    let sign = distance / abs(distance)
    distance = abs(distance)
    player.pan = -Float(sign * sqrt(distance / UIScreen.main.bounds.width))
  }
  
}
