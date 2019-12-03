
import Foundation
import SceneKit

class ScoreEffect: Effect {
  
  let delta: CGFloat
  
  init(delta: CGFloat) {
    self.delta = delta
  }
  
  func apply(to game: GameScene) {
    game.score += delta
  }
  
}
