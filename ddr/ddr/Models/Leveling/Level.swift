
import Foundation
import SpriteKit

protocol Level {
  func getCartSpeed() -> CGFloat
  func getFlashlightDecay() -> CGFloat
  func spawn() -> [Oncomer] // called in update loop
  func nodes() -> [SKNode] // called once at start of level
  func isDone() -> Bool
  func shouldWait(_ game: GameScene) -> Bool
  func alertWaiting()
  func alertNotWaiting()
}
