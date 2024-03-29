
import UIKit
import SpriteKit

class Bat: Oncomer {
  
  static let WHOOSH_FILE = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  static let SPLAT_FILE = Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!
  static let FLAP_FILE = Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!
  static let FLAP_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 0.6
  
  let flapping: Emitter
  let whoosh: Emitter
  let splat: Emitter
  
  // factory method
  static func getTrainingBat(position: ScreenThird, speed: CGFloat = Bat.DEFAULT_SPEED) -> Bat{
    let bat = Bat(position: position, speed: speed)
    bat.collisionEffects = [] // training bats can't actually hurt you
    bat.lightingBitMask = 0 // not affected by flashlight
    return bat
  }
  
  static func spawningFunc(speed: CGFloat = Bat.DEFAULT_SPEED) -> (Spawner<Oncomer>?) -> Bat {
    return { spawner in {
        Bat(spawner: spawner, speed: speed)
      }()
    }
  }
  
  convenience init(spawner: Spawner<Oncomer>? = nil, speed: CGFloat = Bat.DEFAULT_SPEED) {
    self.init(
      spawner: spawner,
      position: ScreenThird.allCases.randomElement()!,
      speed: speed
    )
  }
  
  init(spawner: Spawner<Oncomer>? = nil, position: ScreenThird, speed: CGFloat) {
    // my instance vars
    let texture1 = SKTexture(imageNamed: "bat1")
    let texture2 = SKTexture(imageNamed: "bat2")
    let texture3 = SKTexture(imageNamed: "bat3")
    
    // start flapping
    flapping = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.FLAP_FILE, maxZMagnitude: GameScene.HORIZON)
    flapping.isRepeated = true
    flapping.speed = speed / Bat.FLAP_VELOCITY_CONVERSION
    flapping.start()
    
    // create emitters for whoosh and splat sounds
    whoosh = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.WHOOSH_FILE, maxZMagnitude: GameScene.HORIZON)
    whoosh.volume = 0.7
    whoosh.speed = 2
    splat = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.SPLAT_FILE, maxZMagnitude: GameScene.HORIZON)
    
    // init super vars
    super.init(
      spawner: spawner,
      emitters: [flapping, whoosh, splat],
      collisionEffects: [
        SoundEffect(emitter: splat),
        LoseLifeEffect()
      ],
      passEffects: [
        SoundEffect(emitter: whoosh),
        ScoreEffect(delta: speed * GameScene.BAT_SPEED_POINT_CONVERSION)
      ],
      goneEffects: [],
      textures: [texture1,texture2,texture3],
      color: SKColor.clear,
      size: CGSize(
        width: texture1.size().width * 1.75,
        height: texture1.size().height * 1.75),
      lightingBitMask: 0b0001,
      collisionThird: position
    )
    
    self.position = CGPoint(
      x: position.getX(),
      y: Bat.DEFAULT_Y
    )
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func despawn() {
    flapping.stop() // todo: fix audio manager to prevent memory leak in long games
    super.despawn()
  }
}
