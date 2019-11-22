
import Foundation
import SpriteKit

class BoundedLevel: Level {
  
  let spawners: [Spawner<Oncomer>]
  let cartSpeed: CGFloat
  
  init (spawners: [Spawner<Oncomer>], cartSpeed: CGFloat) {
    self.spawners = spawners
    self.cartSpeed = cartSpeed
  }
  
  func getCartSpeed() -> CGFloat {
    return cartSpeed
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
}
