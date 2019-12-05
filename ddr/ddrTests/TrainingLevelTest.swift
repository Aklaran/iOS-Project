
import XCTest
import SpriteKit
@testable import ddr

class TrainingLevelTest: XCTestCase {
  
  var _game : GameScene?
  var game = GameScene()
  var level = TrainingLevel(id: "", steps: [], cartSpeed: 1, flashlightDecay: 0)

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    level = TrainingLevel(id: "testLevel", steps: [MessageStep(messageNodes: [], duration: 0.1)], cartSpeed: 1, flashlightDecay: 0)
  }

  func testGetCartSpeed() {
    XCTAssertEqual(1, level.getCartSpeed())
    level = TrainingLevel(id: "testLevel", steps: [], cartSpeed: 10, flashlightDecay: 10)
    XCTAssertEqual(10, level.getCartSpeed())
  }
  
  func testGetFlashlightDecay() {
    XCTAssertEqual(0, level.getFlashlightDecay())
    level = TrainingLevel(id: "testLevel", steps: [], cartSpeed: 1, flashlightDecay: 10)
    XCTAssertEqual(10, level.getFlashlightDecay())
  }
  
  func testSpawn() {
    XCTAssertEqual([], level.spawn())
  }
  
  func testNodes() {
    XCTAssertEqual([], level.nodes())
    let testNode = SKNode()
    level = TrainingLevel(
      id: "testLevel",
      steps: [
        MessageStep(messageNodes: [testNode], duration: 2)
      ],
      cartSpeed: 1,
      flashlightDecay: 0
    )
    XCTAssertEqual([testNode], level.nodes())
  }
  
  func testIsDone() {
    XCTAssertFalse(level.isDone())
    TrainingLevel.completedLevels.append("testLevel")
    XCTAssert(level.isDone())
    TrainingLevel.completedLevels = []
    level = TrainingLevel(id: "testLevel", steps: [MessageStep(messageNodes: [], duration: 0)], cartSpeed: 1, flashlightDecay: 0)
    level.alertWaiting()
    XCTAssert(level.isDone())
  }
  
  func testAlerts() {
    let testNode = SKNode()
    level = TrainingLevel(
      id: "testLevel",
      steps: [
        MessageStep(messageNodes: [testNode], duration: 2)
      ],
      cartSpeed: 1,
      flashlightDecay: 0
    )
    XCTAssert(testNode.isHidden)
    level.alertWaiting()
    XCTAssertFalse(testNode.isHidden)
    level.alertNotWaiting()
    XCTAssert(testNode.isHidden)
  }
  
  func testShouldWait() {
    XCTAssert(level.shouldWait(game))
  }
  
}
