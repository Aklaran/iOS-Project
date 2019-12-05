
import UIKit
import SpriteKit

class Battery: Oncomer {
  
  static let IMPACT_FILE = Bundle.main.path(forResource: "charge.mp3", ofType: nil)!
  static let MOVE_FILE = Bundle.main.path(forResource: "electricity.wav", ofType: nil)!
  
  static let MOVE_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 3 / 4

  let impact: Emitter
  let moving: Emitter
   
  static func spawningFunc(speed: CGFloat = Bat.DEFAULT_SPEED) -> (Spawner<Oncomer>?) -> Battery {
    return { spawner in {
        Battery(spawner: spawner, speed: speed)
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
    let texture = SKTexture(imageNamed: "battery3")
    
    // start flapping
    moving = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Battery.MOVE_FILE, maxZMagnitude: GameScene.HORIZON)
    moving.isRepeated = true
    moving.speed = speed / Battery.MOVE_VELOCITY_CONVERSION
    moving.start()
    
    // create emitters for whoosh and splat sounds
    impact = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Battery.IMPACT_FILE, maxZMagnitude: GameScene.HORIZON)
    impact.volume = 0.5
    impact.speed = 2
    
    // init super vars
    super.init(
      spawner: spawner,
      emitters: [impact, moving],
      collisionEffects: [
        SoundEffect(emitter: impact),
        AddBatteryEffect()
      ],
      passEffects: [
      ],
      goneEffects: [],
      texture: texture,
      color: SKColor.clear,
      size: texture.size(),
      lightingBitMask: 0b0001,
      collisionThird: position
    )
    
    zPosition = GameScene.HORIZON
    
    self.position = CGPoint(
      x: position.getX(),
      y: Battery.DEFAULT_Y
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
    moving.stop();
    super.despawn()
  }
}
