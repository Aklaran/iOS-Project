
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
    level = TrainingLevel(id: "testLevel", steps: [], cartSpeed: 1, flashlightDecay: 0)
    XCTAssertEqual(10, level.getCartSpeed())
  }

}
