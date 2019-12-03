
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
    level = TrainingLevel(id: "testLevel", steps: [], cartSpeed: 1, flashlightDecay: 0)
  }

  func testGetCartSpeed() {
    XCTAssertEqual(1, level.getCartSpeed())
    level = TrainingLevel(id: "testLevel", steps: [], cartSpeed: 10, flashlightDecay: 10)
    XCTAssertEqual(10, level.getCartSpeed())
  }
  
  func testGetFlashlightDecay() {
    XCTAssertEqual(1, level.getFlashlightDecay())
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
  
}
