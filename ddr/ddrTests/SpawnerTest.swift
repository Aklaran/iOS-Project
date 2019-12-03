
import XCTest
import SpriteKit
@testable import ddr


class SpawnerTest: XCTestCase {
  
  var _game : GameScene?
  var game = GameScene()
  var spawner = try! Spawner(maxSpawned: 1, getNewSpawn: Bat.spawningFunc())

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    spawner = try! Spawner(maxSpawned: 1, getNewSpawn: Bat.spawningFunc())
  }
  
  func testSpawn() {
    spawner = Spawner(maxSpawned: 10, minSpawned: 1, maxConcurrent: 2, cooldown: 0.5, getNewSpawn: Bat.spawningFunc(), pSpawn: 0)
    XCTAssertNil(spawner.spawn())
    spawner = Spawner(maxSpawned: 10, minSpawned: 1, maxConcurrent: 2, cooldown: 0.5, getNewSpawn: Bat.spawningFunc(), pSpawn: 1)
    XCTAssertNotNil(spawner.spawn())
  }

}
