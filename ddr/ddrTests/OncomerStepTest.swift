
import XCTest
import SpriteKit
@testable import ddr

class OncomerStepTest: XCTestCase {

  var _game : GameScene?
  var game = GameScene()
  var step = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var step2 = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var step3 = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var step4 = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var step5 = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var step6 = OncomerStep(oncomer: Bat.init(), desireToHit: false)
  var bat = Bat.init()

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    bat = Bat.getTrainingBat(position: ScreenThird.RIGHT)
    step = OncomerStep(
      oncomer: bat,
      message: "lean right",
      desireToHit: true
    )
    step2 = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
      message: "lean right",
      desireToHit: false
    )
    step3 = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
      message: "lean right",
      desireToHit: false
    )
    step4 = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
      message: "lean right",
      desireToHit: true
    )
    step5 = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
      message: "lean right",
      desireToHit: true
    )
    step6 = OncomerStep(
      oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
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
  
  func testProgression() {
    step.alertNotWaiting()
    XCTAssertFalse(step.shouldWait(game))
    XCTAssertFalse(step.isDone())
    bat.zPosition = 1
    bat.speed = 10
    XCTAssertTrue(step.shouldWait(game))
    XCTAssertFalse(step.isDone())
    let node = step.instructionNodes[0]
    XCTAssertTrue(node.isHidden)
    step.alertWaiting()
    XCTAssertFalse(node.isHidden)
    step.alertNotWaiting()
    XCTAssertTrue(node.isHidden)
    XCTAssertTrue(step.shouldWait(game))
    XCTAssertFalse(step.isDone())
    bat.zPosition = -3 * GameScene.HORIZON
    XCTAssertFalse(step.shouldWait(game))
    XCTAssertFalse(step.isDone())
  }

}
