
import XCTest
import SpriteKit
@testable import ddr

class EffectTests: XCTestCase {
  
  var _game : GameScene?
  var game = GameScene()
  
  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
  }
  
  func testHideEffect() {
    // todo
  }

}
