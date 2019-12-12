
import Foundation
import SpriteKit

class AudioManager {
  
  var emitters: Set<Emitter> = Set()
  private var listenerPosition = CGPoint(x: 0, y: 0)
  
  func createEmitter(soundFile: String, maxZMagnitude: CGFloat) -> Emitter {
    let emitter = Emitter(soundFile: soundFile, maxZMagnitude: maxZMagnitude)
    emitters.insert(emitter)
    return emitter
  }
  
  func updateListenerPosition(to newPosition: CGPoint) {
    listenerPosition = newPosition
    for emitter in emitters {
      emitter.updateDestination(listenerPosition)
    }
  }
  
  func deleteEmitter(_ emitter: Emitter) {
    emitters.remove(emitter)
  }
  
//  func deleteEmitters(emittersToDelete: [Emitter]) {
//    emitters = emitters.filter({ x in emittersToDelete.contains(where: {y in x === y})})
//  }
  
}
