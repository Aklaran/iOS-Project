
import UIKit
import SpriteKit

class Bullet: SKSpriteNode {
  
  init(imageName: String, bulletSound: String?) {
    let texture = SKTexture(imageNamed: imageName)
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    if(bulletSound != nil){
      run(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
    }
  }

  required init?(coder aDecoder: NSCoder) {
    // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
    super.init(coder: aDecoder)
  }
  
}
