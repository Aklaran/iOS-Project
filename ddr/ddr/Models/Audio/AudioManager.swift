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
  private var listenerPosition = CGPoint(x: 0, y: 0)
  
  func createEmitter(soundFile: String, maxZMagnitude: CGFloat) -> Emitter {
    let emitter = Emitter(soundFile: soundFile, maxZMagnitude: maxZMagnitude)
    emitters.append(emitter)
    return emitter
  }
  
  func updateListenerPosition(to newPosition: CGPoint) {
    listenerPosition = newPosition
    for emitter in emitters {
      emitter.updateDestination(listenerPosition)
    }
  }
  
}
