
import Foundation
import SpriteKit

class TrainingLevel: Level {
  
  let id: String
  let cartSpeed: CGFloat
  let flashlightDecay: CGFloat
  let steps: [TrainingStep]
  
  var currentStepIndex = 0
  
  var currentStep: TrainingStep {
    get {
      return steps[currentStepIndex]
    }
  }
  
  init (id: String, steps: [TrainingStep], cartSpeed: CGFloat, flashlightDecay: CGFloat) {
    self.id = id
    self.cartSpeed = cartSpeed
    self.flashlightDecay = flashlightDecay
    self.steps = steps
  }
  
  func getCartSpeed() -> CGFloat {
    return cartSpeed
  }
  
  func getFlashlightDecay() -> CGFloat {
    return flashlightDecay
  }
  
  func spawn() -> [Oncomer] {
    return currentStep.spawn()
  }
  
  func nodes() -> [SKNode] {
    var result: [SKNode] = []
    for step in steps {
      result = result + step.getNodes()
    }
    return result
  }
  
  func alertWaiting() {
    currentStep.alertWaiting()
  }
  
  func alertNotWaiting() {
    currentStep.alertNotWaiting()
  }
  
  func shouldWait(_ game: GameScene) -> Bool {
    return currentStep.shouldWait(game)
  }
  
  func isDone() -> Bool {
    
    // skip level if user has already completed it
    if PlayerData.singleton.getTrainingsSeen().contains(id) {
      return true
    }
    
    if currentStep.isDone() {
      currentStep.alertNotWaiting() // just to make sure this gets called
      currentStepIndex = currentStepIndex + 1
      if currentStepIndex >= steps.count {
        PlayerData.singleton.addToTrainingsSeen(levelId: id) // skip this training in the future
        return true
      }
    }
    return false
  }
}
