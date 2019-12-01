
import Foundation
import SpriteKit

protocol TrainingStep {
  
  // all the extra nodes used by the training step
  func getNodes() -> [SKNode]
  
  // decides if waiting should happen based on the game state
  func shouldWait(_ game: GameScene) -> Bool
  
  // update nodes as necessary
  func alertWaiting()
  
  // update nodes as necessary
  func alertNotWaiting()
  
  // get anything that should be spawned
  func spawn() -> [Oncomer]
  
  // true iff the current step has completed
  func isDone() -> Bool
  
}
