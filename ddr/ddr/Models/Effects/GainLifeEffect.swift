
import Foundation

class GainLifeEffect: Effect {
  func apply(to game: GameScene) {
    if let gained = game.rider?.gainLife() {
      if gained {
        game.drawHeart()
      }
    }
  }
}
