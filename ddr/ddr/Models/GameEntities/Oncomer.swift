
import Foundation
import SpriteKit

enum ScreenThird: Int, CaseIterable {
  case LEFT = 0
  case MIDDLE = 1
  case RIGHT = 2
  
  func getX() -> CGFloat{
    return (CGFloat(self.rawValue) * (GameScene.WIDTH / 3)) + CGFloat(GameScene.WIDTH / 6)
  }
  
  static func of(x: CGFloat) -> ScreenThird {
    return ScreenThird(rawValue: min(2, max(0, Int(x / (GameScene.WIDTH / 3)))))!
  }
  
}

class Oncomer: SKSpriteNode, Spawnable {
  
  let spawner: Spawner<Oncomer>?
  let emitters: [Emitter]
  let textures: [SKTexture]
  var collisionEffects: [Effect]
  var passEffects: [Effect]
  var goneEffects: [Effect]
  var isDead = false
  
  var collisionThird: ScreenThird
  
  override var zPosition: CGFloat {
    didSet {
      // update sound
      emitters.forEach({ $0.updateZ(zPosition) })
      
      // progress from horizon to player in (0, 1)
      let zProgress = (GameScene.HORIZON  - abs(zPosition)) / GameScene.HORIZON
      
      // update visual - scale
      xScale =  zProgress
      yScale = xScale
      
      // and hide iff they have passed 0
      // Note: this makes HideEffect obselete
      if (zPosition < 0) {
        self.isHidden = true
      }
      else {
        self.isHidden = false
      }
      
      // update visual - screen position
      // oncomers move from vanishing pt in middle of screen
      // and progress to either edge of screen or the middle
      let modifier = 1 + CGFloat(self.collisionThird.rawValue - 1) * zProgress
      self.position.x = (GameScene.WIDTH / 2) * modifier
    }
  }
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      emitters.forEach({ $0.updatePosition(position) })
    }
  }
  
  init (
    spawner: Spawner<Oncomer>?,
    emitters: [Emitter],
    collisionEffects: [Effect],
    passEffects: [Effect],
    goneEffects: [Effect],
    textures: [SKTexture],
    color: UIColor,
    size: CGSize,
    lightingBitMask: UInt32,
    collisionThird: ScreenThird)
  {
    self.spawner = spawner
    self.collisionEffects = collisionEffects
    self.passEffects = passEffects
    self.goneEffects = goneEffects
    self.textures = textures
    self.emitters = emitters
    self.collisionThird = collisionThird
    super.init(texture: self.textures.first(where: { _ in true }), color: color, size: size)
    super.lightingBitMask = lightingBitMask
    self.collisionEffects = self.collisionEffects + [ KillOncomerEffect(oncomer: self) ]
    self.passEffects = self.passEffects + [ HideEffect(nodeToHide: self) ]
    self.goneEffects = self.goneEffects + [ KillOncomerEffect(oncomer: self) ]
    if self.textures.count > 1 {
      animate();
    }
    
    zPosition = GameScene.HORIZON
    // these are not set in the first update of z because super has not been inited yet
    xScale = 0
    yScale = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func despawn() {
    spawner?.despawn(self)
  }
  
  func collidesWith(position: CGPoint) -> Bool {
    return ScreenThird.of(x: self.position.x) == ScreenThird.of(x: position.x)
  }
  
//  could not use because rider headPosition != rider position
//  func collidesWith(node: SKNode) -> Bool {
//    return collidesWith(position: node.position)
//  }
  
  func move(withAdditionalDistance distance : CGFloat = 0) {
    self.zPosition = self.zPosition - self.speed - distance
  }
  
  func isGone() -> Bool {
    return isDead
      || abs(zPosition) > GameScene.HORIZON
  }
  
  func applyCollisionEffects(to game: GameScene) {
    Oncomer.applyAllEffects(collisionEffects, to: game)
  }
  
  func applyPassEffects(to game: GameScene) {
    Oncomer.applyAllEffects(passEffects, to: game)
  }
  
  func applyGoneEffects(to game: GameScene) {
    Oncomer.applyAllEffects(goneEffects, to: game)
  }
  
  func animate(timePerFrame: TimeInterval = 0.1) {
    self.run(SKAction.repeatForever(SKAction.animate(with: self.textures, timePerFrame: timePerFrame)))
  }
  
  private static func applyAllEffects(_ effects: [Effect], to game: GameScene) {
    for effect in effects {
      effect.apply(to: game)
    }
  }
  
}
