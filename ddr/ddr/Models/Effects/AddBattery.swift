import Foundation

class AddBatteryEffect: Effect {
  func apply(to game: GameScene) {
    game.battery?.addOne()
  }
}
