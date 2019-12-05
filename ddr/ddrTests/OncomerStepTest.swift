
import XCTest
import SpriteKit
@testable import ddr

class OncomerStepTest: XCTestCase {

  var _game : GameScene?
  var game = GameScene()
  var step = try! OncomerStep(oncomer: Bat.init(), desireToHit: false)
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
  
  func testInit() {
    do {
      let _ = try OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
        desireToHit: false
      )
      let _ = try OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
        desireToHit: false
      )
      let _ = try OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
        desireToHit: true
      )
      let _ = try OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
        desireToHit: true
      )
      let _ = try OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
        desireToHit: false
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
        message: "lean right",
        desireToHit: false
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
        message: "lean right",
        desireToHit: false
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
        message: "lean right",
        desireToHit: true
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
        message: "lean right",
        desireToHit: true
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
        message: "lean right",
        desireToHit: true
      )
      let _ = OncomerStep(
        oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
        message: "lean right",
        desireToHit: false
      )
    }
    catch {
      XCTAssert(false) // these should not throw
    }
  }

}
