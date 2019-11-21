
import Foundation

class LoseLifeEffect: Effect {
  func apply(to game: GameScene) {
    // remove the sprite
    let life = game.lives.popLast()
    life?.removeFromParent()
    
    // record it in rider
    if let currentLives = game.rider?.lives {
      game.rider?.lives = currentLives - 1
    }
  }
}
