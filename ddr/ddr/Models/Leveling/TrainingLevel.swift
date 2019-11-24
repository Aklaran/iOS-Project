
import Foundation
import SpriteKit

class TrainingLevel: Level {
  
  let cartSpeed: CGFloat
  let flashlightDecay: CGFloat
  let steps: [TrainingStep]
  
  var currentStepIndex = 0
  
  var currentStep: TrainingStep {
    get {
      return steps[currentStepIndex]
    }
  }
  
  init (steps: [TrainingStep], cartSpeed: CGFloat, flashlightDecay: CGFloat) {
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
  
  // this is a hacky place to increment the current step
  // sorry, as a whole levels could have been designed better
  // but this is what we have now and this is the best place
  // I can think of to put this logic
  func isDone() -> Bool {
    if currentStep.isDone() {
      currentStepIndex = currentStepIndex + 1
      if currentStepIndex >= steps.count {
        return true
      }
    }
    return false
  }
}
