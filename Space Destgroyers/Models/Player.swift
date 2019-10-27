import UIKit
import SpriteKit

class Player: SKSpriteNode {
  
  private var canFire = true
  private var invincible = false
  // should the player live after a hit or die?
  private var lives:Int = 3 {
    didSet {
      if (lives < 0) {
        kill()
      } else {
        respawn()
      }
    }
  }
  
  init() {
    let texture = SKTexture(imageNamed: "player1")
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    // preparing player for collisions once we add physics...
    
    
    animate()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // we want the player image to alternate between one with and without jet flames so it looks like it's moving
  private func animate(){
    var playerTextures:[SKTexture] = []
    for i in 1...2 {
      playerTextures.append(SKTexture(imageNamed: "player\(i)"))
    }
    let playerAnimation = SKAction.repeatForever(SKAction.animate(with: playerTextures, timePerFrame: 0.1))
    self.run(playerAnimation)
  }
  
  func die (){
    // logic to be determined shortly
  }
  
  func kill(){
    // logic to be determined shortly
  }
  
  func respawn(){
    // logic to be determined shortly
  }
  
  func fireBullet(scene: SKScene){
    if !canFire {
      return
    } else {
      canFire = false   // if we comment out or set to true, rapid firing is possible
      let bullet = PlayerBullet(imageName: "laser.png" ,bulletSound: "laser-sound.mp3")
      bullet.position.x = self.position.x
      bullet.position.y = self.position.y + self.size.height/2
      scene.addChild(bullet)
      let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y:scene.size.height + bullet.size.height), duration: 1.0)
      let removeBulletAction = SKAction.removeFromParent()
      bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
      // our delay to stop rapid firing...
      let waitToEnableFire = SKAction.wait(forDuration: 0.5)
      run(waitToEnableFire,completion:{
        self.canFire = true
      })
    }
  }
  
}
