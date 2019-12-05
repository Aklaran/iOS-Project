
import UIKit
import SpriteKit

class Bat: Oncomer {
  
  static let WHOOSH_FILE = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  static let SPLAT_FILE = Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!
  static let FLAP_FILE = Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!
  static let FLAP_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 3 / 4
  
  let flapping: Emitter
  let whoosh: Emitter
  let splat: Emitter
  
  // factory method
  static func getTrainingBat(position: ScreenThird, speed: CGFloat = Bat.DEFAULT_SPEED) -> Bat{
    let bat = Bat(position: position, speed: speed)
    bat.collisionEffects = [] // training bats can't actually hurt you
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
    whoosh.volume = 0.5
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
      size: texture1.size(),
      lightingBitMask: 0b0001,
      collisionThird: position
    )
    
    zPosition = GameScene.HORIZON
    
    self.position = CGPoint(
      x: position.getX(),
      y: Bat.DEFAULT_Y
    )
    
    // these are not set in the first update of z because super has not been inited yet
    xScale = 0
    yScale = 0
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
