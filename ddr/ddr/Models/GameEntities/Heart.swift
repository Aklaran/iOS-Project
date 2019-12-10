
import Foundation
import UIKit
import SpriteKit

class Heart: Oncomer {
  
  static let DEFAULT_Y = GameScene.HEIGHT * 3 / 4
  static let TEXTURE_NAME = "heart"
  
  static func spawningFunc(speed: CGFloat = 1.5) -> (Spawner<Oncomer>?) -> Heart {
    return { spawner in {
        Heart(spawner: spawner, speed: speed)
      }()
    }
  }
  
  convenience init(spawner: Spawner<Oncomer>? = nil, speed: CGFloat = 1.5) {
    self.init(
      spawner: spawner,
      position: ScreenThird.allCases.randomElement()!,
      speed: speed
    )
  }
  
  init(spawner: Spawner<Oncomer>? = nil, position: ScreenThird, speed: CGFloat = 1.5) {
    // start heart sound
    // todo
    
    // other sounds()
    // todo
    
    // texture
    let texture = SKTexture(imageNamed: Heart.TEXTURE_NAME)
    
    super.init(
      spawner: spawner,
      emitters: [],
      collisionEffects: [],
      passEffects: [],
      goneEffects: [],
      textures: [texture],
      color: SKColor.clear,
      size: texture.size(),
      lightingBitMask: 0b000,
      collisionThird: position
    )
    
    self.position = CGPoint(
      x: position.getX(),
      y: Heart.DEFAULT_Y
    )
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
