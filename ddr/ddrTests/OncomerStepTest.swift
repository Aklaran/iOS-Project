
import XCTest
import SpriteKit
@testable import ddr

class OncomerStepTest: XCTestCase {

  var _game : GameScene?
  var game = GameScene()
  var step = OncomerStep(oncomer: Bat.init(), desireToHit: false)

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    step = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
      message: "lean right",
      desireToHit: false
    )
  }
  
  func testSimpleMethods() {
    XCTAssertFalse(step.shouldWait(game))
    XCTAssertFalse(step.isDone())
    XCTAssertEqual(1, step.getNodes().count)
    XCTAssertNotEqual([], step.spawn())
    XCTAssertEqual([], step.spawn())
  }

}
