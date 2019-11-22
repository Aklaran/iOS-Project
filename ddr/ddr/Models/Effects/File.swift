
import Foundation
import SpriteKit

class HideEffect: Effect {
  
  let nodeToHide: SKNode
  
  init(nodeToHide: SKNode) {
    self.nodeToHide = nodeToHide
  }
  
  func apply(to game: GameScene) {
    nodeToHide.isHidden = true
  }
}
