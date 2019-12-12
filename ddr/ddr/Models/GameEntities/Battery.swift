
import Foundation
import SpriteKit
import UIKit

class Battery: Oncomer {
  
  static let BUZ_FILE = Bundle.main.path(forResource: "electricity.mp3", ofType: nil)!
  static let CHARGE_FILE = Bundle.main.path(forResource: "charge2.mp3", ofType: nil)!
  static let TEXTURE = SKTexture(imageNamed: "battery3")
  static let DEFAULT_Y = GameScene.HEIGHT * 5 / 8
  
  var buzzingSound: Emitter
  let chargeSound: Emitter
  
  // hacky fix
  override var isDead: Bool {
    didSet {
      if isDead {
        buzzingSound.stop()
      }
    }
  }
  
  static func spawningFunc(speed: CGFloat = 0.5) -> (Spawner<Oncomer>?) -> Battery {
    return { spawner in {
        Battery(spawner: spawner, speed: speed)
      }()
    }
  }
  
  convenience init(spawner: Spawner<Oncomer>? = nil, speed: CGFloat = 0.5) {
    self.init(
      spawner: spawner,
      position: ScreenThird.allCases.randomElement()!,
      speed: speed
    )
  }
  
  init (spawner: Spawner<Oncomer>? = nil, position: ScreenThird, speed: CGFloat = 0.5) {
    
    // start buzzing
    buzzingSound = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Battery.BUZ_FILE, maxZMagnitude: GameScene.HORIZON)
    buzzingSound.isRepeated = true
    buzzingSound.speed = 2
    buzzingSound.start()
    
    // charge sound
    chargeSound = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Battery.CHARGE_FILE, maxZMagnitude: GameScene.HORIZON)
//    chargeSound.speed = 2
    
    super.init(
      spawner: spawner,
      emitters: [buzzingSound, chargeSound],
      collisionEffects: [ChargeEffect(), SoundEffect(emitter: chargeSound)],
      passEffects: [],
      goneEffects: [],
      textures: [Battery.TEXTURE],
      color: SKColor.clear,
      size: CGSize(
        width: Battery.TEXTURE.size().width * 0.5,
        height: Battery.TEXTURE.size().height * 0.5
      ),
      lightingBitMask: 000000,
      collisionThird: position
    )
    
    self.position = CGPoint(
      x: position.getX(),
      y: Battery.DEFAULT_Y
    )
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func despawn() {
    buzzingSound.stop() // todo: fix audio manager to prevent memory leak in long games
    super.despawn()
  }
}
