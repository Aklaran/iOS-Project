

import XCTest
import SpriteKit
@testable import ddr

/*
 Note: these tests sometimes have obscure errors when testing on a physical device
 */
class StandardLevelTest: XCTestCase {
  
  var _game : GameScene?
  var game = GameScene()
  var level = StandardLevel(spawners: [], cartSpeed: 1, flashlightDecay: 0)

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    level = StandardLevel(
      spawners: [
        try! Spawner(minSpawned: 1, getNewSpawn: Bat.spawningFunc())
      ],
      cartSpeed: 1,
      flashlightDecay: 0
    )
  }
  
  func testGetCartSpeed() {
    XCTAssertEqual(1, level.getCartSpeed())
    level = StandardLevel(spawners: [], cartSpeed: 10, flashlightDecay: 0)
    XCTAssertEqual(10, level.getCartSpeed())
  }
  
  func testIsDone() {
    XCTAssertFalse(level.isDone())
    level = StandardLevel(spawners: [], cartSpeed: 10, flashlightDecay: 0)
    XCTAssert(level.isDone())
  }
  
  func testSpawn() {
    level = StandardLevel(spawners: [], cartSpeed: 10, flashlightDecay: 0)
    XCTAssertEqual([], level.spawn())
  }
  
  func testAlertNotWaiting() {
    level.alertNotWaiting() // should do nothing
  }
  
  func testAlertWaiting() {
    level.alertWaiting() // should do nothing
  }
  
  func testNodes() {
    XCTAssertEqual([], level.nodes())
  }
  
  func testGetFlashlightDecay() {
    XCTAssertEqual(0, level.getFlashlightDecay())
    level = StandardLevel(spawners: [], cartSpeed: 10, flashlightDecay: 1)
    XCTAssertEqual(1, level.getFlashlightDecay())
  }
  
  func testShouldWait() {
    XCTAssertFalse(level.shouldWait(game)) // standard levels never should wait
  }

}
