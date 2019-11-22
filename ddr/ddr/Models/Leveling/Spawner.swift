
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
  private let pSpawn: CGFloat // the probability that the spawner should spawn at any given update
  private let getNewSpawn: (Spawner) -> T
  
  private var canSpawnAfter: Date
  
  private var currentlySpawned: Set<T>
  private var totalSpawned: Int
  
  
  
  init(maxSpawned: Int, minSpawned: Int, maxConcurrent: Int, cooldown: TimeInterval, expectedDuration: TimeInterval, getNewSpawn: @escaping (Spawner) -> T) throws {
    self.maxSpawned = maxSpawned
    self.minSpawned = minSpawned
    self.maxConcurrent = maxConcurrent
    self.getNewSpawn = getNewSpawn
    self.cooldown = cooldown
    
    self.canSpawnAfter = Date()
    self.currentlySpawned = []
    self.totalSpawned = 0
    
    // calculate the probability that the spawner should spawn at a given update
    // this does not take max-concurrent or cooldown into account when using
    //    expected duration, but I think it is good enough
    if self.minSpawned > 0 {
      // set the probability to reach the min spawned at the expected duration,
      //    assuming spawn() is called in the update loop
      self.pSpawn = CGFloat(self.minSpawned) * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else if self.maxSpawned > 0 {
      // there is no minimum, so shot for spawning half of the maxSpawned value
      //    before reaching the expected duration
      self.pSpawn = CGFloat(self.maxSpawned) / 2.0 * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else {
      // i don't know a meaningful way to handle this case
      print("please make sure at least one of (maxSpawned, minSpawned) is positive")
      throw NSError()
    }
  }
  
  func spawn() -> T?{
    if Date() > canSpawnAfter
        && currentlySpawned.count < maxConcurrent
        && totalSpawned < maxSpawned
        && CGFloat(Float.random(in: 0...1)) < pSpawn {
      canSpawnAfter = Date().addingTimeInterval(cooldown)
      let newSpawn = getNewSpawn(self)
      currentlySpawned.insert(newSpawn)
      totalSpawned = totalSpawned + 1
      return newSpawn
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
