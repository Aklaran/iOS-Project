
import Foundation

class KillOncomerEffect: Effect {
  
  let oncomer: Oncomer
  
  init(oncomer: Oncomer) {
    self.oncomer = oncomer
  }
  
  func apply(to game: GameScene) {
    oncomer.despawn()
    oncomer.isDead = true // make sure oncomer isGone()
    oncomer.removeFromParent()
    game.oncomers.remove(oncomer)
  }
  
}
