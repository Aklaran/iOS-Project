
import Foundation
import SpriteKit

protocol Spawnable: Hashable {
  func despawn()
}

class Spawner<T: Spawnable>{
  
  private let maxSpawned: Int
  private let minSpawned: Int
  private let maxConcurrent: Int
  private let cooldown: TimeInterval
  private let pSpawn: CGFloat
  private let getNewSpawn: (Spawner) -> T
  
  private var canSapwnAfter: Date
  
  private var currentlySpawned: Set<T>
  private var totalSpawned: Int
  
  
  
  init(maxSpawned: Int, minSpawned: Int, maxConcurrent: Int, cooldown: TimeInterval, expectedDuration: TimeInterval, getNewSpawn: @escaping (Spawner) -> T) throws {
    self.maxSpawned = maxSpawned
    self.minSpawned = minSpawned
    self.maxConcurrent = maxConcurrent
    self.getNewSpawn = getNewSpawn
    self.cooldown = cooldown
    
    self.canSapwnAfter = Date()
    self.currentlySpawned = []
    self.totalSpawned = 0
    
    if self.minSpawned > 0 {
      self.pSpawn = CGFloat(self.minSpawned) * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else if self.maxSpawned > 0 {
      self.pSpawn = CGFloat(self.maxSpawned) / 2.0 * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else {
      print("please make sure at least one of (maxSpawned, minSpawned) is positive")
      throw NSError()
    }
  }
  
  func spawn() -> T?{
    if Date() > canSapwnAfter
        && currentlySpawned.count < maxConcurrent
        && totalSpawned < maxSpawned
        && CGFloat(Float.random(in: 0...1)) < pSpawn {
      canSapwnAfter = Date().addingTimeInterval(cooldown)
      return getNewSpawn(self)
    }
    return nil
  }
  
  func despawn(_ spawnable: T) {
    currentlySpawned.remove(spawnable)
  }
  
  func isDone() -> Bool {
    return totalSpawned >= minSpawned
  }
  
}
