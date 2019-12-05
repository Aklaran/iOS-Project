
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
  private let getNewBattery: (Spawner) -> T
  private let getNewSpawn: (Spawner) -> T
  
  private var canSpawnAfter: Date
  private var currentlySpawned: Set<T>
  private var totalSpawned: Int
  
  // a infinite level might want to change this
  var pSpawn: CGFloat // the probability that the spawner should spawn at any given update
  
  // NOTE: a negative maxSpawned value makes the spawner infinite. The min spawned value will be ignored
  // in this case and the isDone() will always return false
  init(
    maxSpawned: Int,
    minSpawned: Int,
    maxConcurrent: Int,
    cooldown: TimeInterval,
    getNewBattery: @escaping (Spawner) -> T,
    getNewSpawn: @escaping (Spawner) -> T,
    pSpawn: CGFloat
  ) {
    self.maxSpawned = maxSpawned
    self.minSpawned = minSpawned
    self.maxConcurrent = maxConcurrent
    self.getNewBattery = getNewBattery
    self.getNewSpawn = getNewSpawn
    self.cooldown = cooldown
    self.pSpawn = pSpawn
    
    self.canSpawnAfter = Date()
    self.currentlySpawned = []
    self.totalSpawned = 0
  }
  
  convenience init(maxSpawned: Int = -1, minSpawned: Int = 0, maxConcurrent: Int = 1, cooldown: TimeInterval = 1, expectedDuration: TimeInterval = 15, getNewBattery: @escaping (Spawner) -> T, getNewSpawn: @escaping (Spawner) -> T) throws {
    
    let pSpawn: CGFloat
    
    // calculate the probability that the spawner should spawn at a given update
    // this does not take max-concurrent or cooldown into account when using
    //    expected duration, but I think it is good enough
    if minSpawned > 0 {
      // set the probability to reach the min spawned at the expected duration,
      //    assuming spawn() is called in the update loop
      pSpawn = CGFloat(minSpawned) * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else if maxSpawned > 0 {
      // there is no minimum, so shot for spawning half of the maxSpawned value
      //    before reaching the expected duration
      pSpawn = CGFloat(maxSpawned) / 2.0 * (CGFloat(GameScene.FPS) / CGFloat(expectedDuration))
    } else {
      // i don't know a meaningful way to handle this case
      print("please make sure at least one of (maxSpawned, minSpawned) is positive")
      throw NSError()
    }
    
    // pass off construction
    self.init(
      maxSpawned: maxSpawned,
      minSpawned: minSpawned,
      maxConcurrent: maxConcurrent,
      cooldown: cooldown,
      getNewBattery: getNewBattery,
      getNewSpawn: getNewSpawn,
      pSpawn: pSpawn
    )
  }
  
  func spawn() -> T? {
    if Date() > canSpawnAfter
        && currentlySpawned.count < maxConcurrent
        && (maxSpawned < 0 || totalSpawned < maxSpawned)
        && CGFloat(Float.random(in: 0...1)) < pSpawn {
      canSpawnAfter = Date().addingTimeInterval(cooldown)
      let newSpawn = getNewSpawn(self)
      currentlySpawned.insert(newSpawn)
      let newBattery = getNewBattery(self)
      currentlySpawned.insert(newBattery)
      totalSpawned = totalSpawned + 1
      return newSpawn
    }
    return nil
  }
  
  func despawn(_ spawnable: T) {
    currentlySpawned.remove(spawnable)
  }
  
  func isDone() -> Bool {
    return totalSpawned >= minSpawned && maxSpawned > 0 // infinte spawners never finish
  }
  
}
