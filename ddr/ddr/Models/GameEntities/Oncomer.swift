
import Foundation
import SpriteKit

class Oncomer: SKSpriteNode {
  
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
