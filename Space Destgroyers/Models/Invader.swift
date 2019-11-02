import UIKit
import SpriteKit
import AVFoundation

//extension CGPoint {
//
//  var xChanged = { print("x changed") }
//
//  override var X {
//    didSet {
//      xChanged()
//    }
//  }
//}

class Invader: SKSpriteNode{
  // we will determine the invader's row/column later, set to (0,0) for now
  var invaderRow = 0
  var invaderColumn = 0
  
  let player: AVAudioPlayer
  
  
  let sound = SKAudioNode(fileNamed: "lab9images/beep.mp3")
  override var position : CGPoint {
    didSet {
      sound.position = position
      player.pan = Float((position.x - UIScreen.main.bounds.width / 2)/(UIScreen.main.bounds.width/2))
    }
  }
  
  
  init() {
    // we have three types of invader images so randomly chose among these
    let randNum = Int(arc4random_uniform(3) + 1)
    let texture = SKTexture(imageNamed: "invader\(randNum)")
    
    
    
    // matt - make invaders have positional sound
    sound.isPositional = true
    //addChild(sound)
    
    //player.play()
    
    // this works now for no known reason:
    let path = Bundle.main.path(forResource: "lab9images/beep.mp3", ofType: nil)!
    let url = URL(fileURLWithPath: path)
    player = try! AVAudioPlayer(contentsOf: url)
    player.numberOfLoops = -1 // makes it loop forever
    player.play()
//    player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: "beep-1"))
    
    
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    self.name = "invader"
    // preparing invaders for collisions once we add physics...
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
    
    let path = Bundle.main.path(forResource: "beep.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    player = try! AVAudioPlayer(contentsOf: url)
    super.init(coder: aDecoder)
  }
  
  
  func fireBullet(scene: SKScene){
    let bullet = InvaderBullet(imageName: "laser", bulletSound: nil)
    bullet.position.x = self.position.x
    bullet.position.y = self.position.y - self.size.height/2
    scene.addChild(bullet)
    let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
    let removeBulletAction = SKAction.removeFromParent()
    bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
  }
}
