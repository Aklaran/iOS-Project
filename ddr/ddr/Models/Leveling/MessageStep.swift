
import Foundation
import SpriteKit

class MessageStep: TrainingStep {
  
  let nodes: [SKNode]
  let duration: TimeInterval
  
  var endTime: Date?
  
  init(messageNodes: [SKNode], duration: TimeInterval) {
    
    self.nodes = messageNodes
    self.duration = duration
    
    // make sure all the nodes are hidden
    hideNodes()
    
  }
  
  func getNodes() -> [SKNode] {
    return nodes
  }
  
  func shouldWait(_ game: GameScene) -> Bool {
    return endTime == nil || Date() > endTime!
  }
  
  func alertWaiting() {
    endTime = Date() + duration
    showNodes()
  }
  
  func alertNotWaiting() {
    hideNodes()
  }
  
  func spawn() -> [Oncomer] {
    return []
  }
  
  func isDone() -> Bool {
    // if the end time is defined and has passed
    // feel free to rewrite this more cleanly
    if let endTime = endTime {
      if Date() > endTime {
        return true
      }
    }
    return false
  }
  
  private func hideNodes() {
    for node in nodes {
      node.isHidden = true
    }
  }
  
  private func showNodes() {
    for node in nodes {
      node.isHidden = false
    }
  }
  
}
