//
//  AudioManager.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 11/2/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import Foundation
import SpriteKit

class AudioManager {
  
  var emitters = [Emitter]()
  let listenerPosition = CGPoint(x: 0, y: 0)
  
  func createEmitter(soundFile: String) -> Emitter {
    let emitter = Emitter(soundFile: soundFile)
    emitters.append(emitter)
    return emitter
  }
  
}
