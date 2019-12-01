
import Foundation
import SpriteKit

class StandardLevel: Level {
  
  let spawners: [Spawner<Oncomer>]
  let cartSpeed: CGFloat
  let flashlightDecay: CGFloat
  
  init (spawners: [Spawner<Oncomer>], cartSpeed: CGFloat, flashlightDecay: CGFloat) {
    self.spawners = spawners
    self.cartSpeed = cartSpeed
    self.flashlightDecay = flashlightDecay
  }
  
  func getCartSpeed() -> CGFloat {
    return cartSpeed
  }
  
  func getFlashlightDecay() -> CGFloat {
    return flashlightDecay
  }
  
  func spawn() -> [Oncomer] {
    var oncomers : [Oncomer] = []
    for spawner in spawners {
      if let oncomer = spawner.spawn() {
        oncomers.append(oncomer)
      }
    }
    return oncomers
  }
  
  // basic levels don't add any other nodes to the scene
  func nodes() -> [SKNode] {
    return []
  }
  
  func isDone() -> Bool {
    return spawners.allSatisfy({ $0.isDone() })
  }

  func shouldWait(_ game: GameScene) -> Bool {
    return false
  }

  func alertWaiting() {}

  func alertNotWaiting() {}
}
