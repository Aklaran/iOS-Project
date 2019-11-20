
import Foundation
import SpriteKit

class Oncomer: SKSpriteNode, Spawnable {
  
  let spawner: Spawner<Oncomer>
  
  init (spawner: Spawner<Oncomer>, texture: SKTexture?, color: UIColor, size: CGSize) {
    self.spawner = spawner
    super.init(texture: texture, color: color, size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func getImage() -> String {
    return ""
  }
  
  func despawn() {
    removeFromParent()
    spawner.despawn(self)
  }
  
  func collidesWith(spriteAt pos: CGPoint) -> Bool {
    return false;
  }
  
  func move() {
    self.zPosition = self.zPosition + self.speed
  }
  
  func move(withAdditionalDistance distance : CGFloat) {
    self.zPosition = self.zPosition + self.speed + distance
  }
  
}
