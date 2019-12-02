
import Foundation
import SpriteKit

class MessageStep: TrainingStep {
  
  let nodes: [SKNode]
  let duration: TimeInterval
  
  var endTime: Date?
  
  convenience init(
    text: String,
    duration: TimeInterval = 3,
    position: CGPoint = CGPoint(x: GameScene.WIDTH / 2, y: GameScene.HEIGHT / 2))
  {
    let node = SKLabelNode()
    node.text = text
    node.position = position
    self.init(messageNodes: [node], duration: duration)
  }
  
  init(messageNodes: [SKNode], duration: TimeInterval) {
    
    self.nodes = messageNodes
    self.duration = duration
    
    self.nodes.forEach{ body in
      body.zPosition = 999 // show the tutorial text above everything else
    }
    
    // make sure all the nodes are hidden
    hideNodes()
    
  }
  
  func getNodes() -> [SKNode] {
    return nodes
  }
  
  func shouldWait(_ game: GameScene) -> Bool {
    guard let endTime = endTime else {
      return true
    }
    return Date() <= endTime
  }
  
  func alertWaiting() {
    guard let _ = endTime else { // because if x == nil does not work...
      endTime = Date(timeIntervalSinceNow: duration)
      showNodes()
      return
    }
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
