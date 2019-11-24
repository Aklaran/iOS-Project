
import Foundation
import SpriteKit

class OncomerStep: TrainingStep {
  
  let instructionNodes: [SKNode]
  let oncomer: Oncomer
  let cooldown: TimeInterval
  let desiredPositions: [OncomerPosition]
  
  var hasSpawned = false
  var endTime: Date?
  
  init(oncomer: Oncomer, instructions: [SKNode], desiredPositions: [OncomerPosition], cooldown: TimeInterval = 1) {
    self.oncomer = oncomer
    self.instructionNodes = instructions
    self.desiredPositions = desiredPositions // the position or positions that we want the rider to be in
    self.cooldown = cooldown
    
    hideInstructions()
  }
  
  func getNodes() -> [SKNode] {
    return instructionNodes
  }
  
  func shouldWait(_ game: GameScene) -> Bool {
    return game.riderWithinStrikingDistance(of: oncomer)
      && desiredPositions.contains(OncomerPosition.of(x: game.rider!.headPosition.x))
  }
  
  func alertWaiting() {
    showInstructions()
  }
  
  func alertNotWaiting() {
    hideInstructions()
    guard let _ = endTime else { // if not nill
      if hasSpawned {
        endTime = Date() + cooldown
      }
      return
    }
  }
  
  func spawn() -> [Oncomer] {
    if !hasSpawned {
      return [oncomer]
    }
    return []
  }
  
  func isDone() -> Bool {
    if let endTime = endTime {
      return hasSpawned
      && oncomer.isGone()
      && Date() > endTime
    }
    return false
  }
  
  private func hideInstructions() {
    for node in instructionNodes {
      node.isHidden = true
    }
  }
  
  private func showInstructions() {
    for node in instructionNodes {
      node.isHidden = false
    }
  }
  
}
