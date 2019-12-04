
import XCTest
import SpriteKit
@testable import ddr


class OncomerTest: XCTestCase {

  var _game : GameScene?
  var game = GameScene()
  var oncomer = Oncomer(spawner: nil, emitters: [], collisionEffects: [], passEffects: [], goneEffects: [], texture: nil, color: UIColor.red, size: CGSize(width: 10, height: 10), lightingBitMask: 0, collisionThird: ScreenThird.MIDDLE)

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    oncomer = Oncomer(
      spawner: nil,
      emitters: [],
      collisionEffects: [],
      passEffects: [],
      goneEffects: [LoseLifeEffect()],
      texture: nil,
      color: UIColor.red,
      size: CGSize(width: 10, height: 10),
      lightingBitMask: 0,
      collisionThird: ScreenThird.MIDDLE
    )
    game.oncomers = [oncomer]
  }
  
  func testGone() {
    XCTAssertEqual(3, game.rider!.lives)
    XCTAssertEqual(1, game.oncomers.count)
    oncomer.applyGoneEffects(to: game)
    XCTAssertEqual(2, game.rider!.lives)
    XCTAssertEqual(0, game.oncomers.count)
  }

}
