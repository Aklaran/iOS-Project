
import Foundation
import SpriteKit

class OncomerStep: TrainingStep {
  
  let instructionNodes: [SKNode]
  let oncomer: Oncomer
  let cooldown: TimeInterval
  let desiredPositions: [ScreenThird]
  
  var hasSpawned = false
  var endTime: Date?
  
  convenience init(oncomer: Oncomer, desireToHit: Bool) throws {
    var desiredPositions: [ScreenThird]
    var tutorialImage: TutorialImage
    if desireToHit {
      desiredPositions = [oncomer.collisionThird]
      switch oncomer.collisionThird {
        case ScreenThird.LEFT: do {
          tutorialImage = TutorialImage(third: 1, rotateRight: false, alternate: false)
        }
        case ScreenThird.MIDDLE: do {
          print("tutorial images don't support this yet...")
          throw NSError() // may never come up...
        }
        case ScreenThird.RIGHT: do {
          tutorialImage = TutorialImage(third: 1, rotateRight: true, alternate: false)
        }
      }
    } else {
      switch oncomer.collisionThird {
        case ScreenThird.LEFT: do {
          desiredPositions = [ScreenThird.RIGHT]
          tutorialImage = TutorialImage(third: 1, rotateRight: true, alternate: false)
        }
        case ScreenThird.MIDDLE: do {
          desiredPositions = [ScreenThird.LEFT, ScreenThird.RIGHT]
          tutorialImage = TutorialImage(third: 1, rotateRight: true, alternate: true)
        }
        case ScreenThird.RIGHT: do {
          desiredPositions = [ScreenThird.LEFT]
          tutorialImage = TutorialImage(third: 1, rotateRight: false, alternate: false)
        }
      }
    }
    self.init(oncomer: oncomer, instructions: [tutorialImage], desiredPositions: desiredPositions)
  }
  
  convenience init(oncomer: Oncomer, message: String, desireToHit: Bool) {
    let desiredPositions: [ScreenThird]
    if desireToHit {
      desiredPositions = [oncomer.collisionThird]
    } else {
      switch oncomer.collisionThird {
        case ScreenThird.LEFT: desiredPositions = [ScreenThird.RIGHT]
        case ScreenThird.MIDDLE: desiredPositions = [ScreenThird.LEFT, ScreenThird.RIGHT]
        case ScreenThird.RIGHT: desiredPositions = [ScreenThird.LEFT]
      }
    }
    let instructionNode = SKLabelNode()
    instructionNode.text = message
    instructionNode.position = CGPoint(x: GameScene.WIDTH / 2, y: GameScene.HEIGHT / 2)
    self.init(oncomer: oncomer, instructions: [instructionNode], desiredPositions: desiredPositions)
  }
  
  init(oncomer: Oncomer, instructions: [SKNode], desiredPositions: [ScreenThird], cooldown: TimeInterval = 1) {
    self.oncomer = oncomer
    self.instructionNodes = instructions
    for node in self.instructionNodes {
      node.zPosition = GameScene.HORIZON * 3
    }
    self.desiredPositions = desiredPositions // the position or positions that we want the rider to be in
    self.cooldown = cooldown
    
    hideInstructions()
  }
  
  func getNodes() -> [SKNode] {
    return instructionNodes
  }
  
  func shouldWait(_ game: GameScene) -> Bool {
    return game.riderWithinStrikingDistance(of: oncomer)
      && !oncomer.isGone()
      && !desiredPositions.contains(ScreenThird.of(x: game.rider!.headPosition.x))
      && oncomer.zPosition >= 0 // has not passed the rider
  }
  
  func alertWaiting() {
    showInstructions()
  }
  
  func alertNotWaiting() {
    hideInstructions()
    guard let _ = endTime else { // if nill
      if hasSpawned {
        endTime = Date() + cooldown
      }
      return
    }
  }
  
  func spawn() -> [Oncomer] {
    if !hasSpawned {
      hasSpawned = true
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
