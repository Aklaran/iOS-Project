
import Foundation

class SoundEffect: Effect {
  
  let emitter: Emitter
  
  init(emitter: Emitter) {
    self.emitter = emitter
  }
  
  func apply(to game: GameScene) {
    emitter.start()
  }
  
}
