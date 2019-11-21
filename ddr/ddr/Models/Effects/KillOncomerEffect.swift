
import Foundation

class KillOncomerEffect: Effect {
  
  let oncomer: Oncomer
  
  init(oncomer: Oncomer) {
    self.oncomer = oncomer
  }
  
  func apply(to game: GameScene) {
    oncomer.despawn()
    oncomer.removeFromParent()
    game.oncomers.remove(oncomer)
  }
  
}
