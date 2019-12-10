
import Foundation
import SpriteKit

class ChargeEffect: Effect {
  
  let percent: CGFloat
  
  init(percent: CGFloat = 34) {
    self.percent = percent
  }
  
  func apply(to game: GameScene) {
    game.rider?.flashlight?.chargeBattery(additionalPercent: percent)
  }
  
}
