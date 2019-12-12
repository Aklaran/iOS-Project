
import Foundation

class KillOncomerEffect: Effect {
  
  let oncomer: Oncomer
  
  init(oncomer: Oncomer) {
    self.oncomer = oncomer
  }
  
  func apply(to game: GameScene) {
    oncomer.despawn()
    oncomer.zPosition = -1 * (GameScene.HORIZON + 1) // make sure oncomer isGone()
    oncomer.removeFromParent()
    game.oncomers.remove(oncomer)
  }
  
}
