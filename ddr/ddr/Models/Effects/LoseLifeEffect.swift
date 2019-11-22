
import Foundation

class LoseLifeEffect: Effect {
  func apply(to game: GameScene) {
    // remove the heart sprite
    let life = game.lives.popLast()
    life?.removeFromParent()
    
    // record it in rider
    game.rider?.loseLife()
  }
}
