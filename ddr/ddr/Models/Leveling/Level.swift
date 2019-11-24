
import Foundation
import SpriteKit

protocol Level {
  func getCartSpeed() -> CGFloat
  func getFlashlightDecay() -> CGFloat
  func spawn() -> [Oncomer] // called in update loop
  func nodes() -> [SKNode] // called once as start of level
  func isDone() -> Bool
}
