
import Foundation
import SpriteKit

class Oncomer: SKSpriteNode, Spawnable {
  
  let spawner: Spawner<Oncomer>
  let emitters: [Emitter]
  let collisionEffects: [Effect]
  let passEffects: [Effect]
  var goneEffects: [Effect]
  
  override var zPosition: CGFloat {
    didSet {
      // update sound
      emitters.forEach({ $0.updateZ(zPosition) })
      
      // update visual
      xScale = (GameScene.HORIZON - abs(zPosition)) / GameScene.HORIZON
      yScale = xScale
    }
  }
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      emitters.forEach({ $0.updatePosition(position) })
    }
  }
  
  init (
    spawner: Spawner<Oncomer>,
    emitters: [Emitter],
    collisionEffects: [Effect],
    passEffects: [Effect],
    goneEffects: [Effect],
    texture: SKTexture?,
    color: UIColor,
    size: CGSize)
  {
    self.spawner = spawner
    self.collisionEffects = collisionEffects
    self.passEffects = passEffects
    self.goneEffects = goneEffects
    self.emitters = emitters
    super.init(texture: texture, color: color, size: size)
    self.goneEffects = self.goneEffects + [ KillOncomerEffect(oncomer: self) ] // adds default behavior
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func getImage() -> String {
    return ""
  }
  
  func despawn() {
    spawner.despawn(self)
  }
  
  func collidesWith(spriteAt pos: CGPoint) -> Bool {
    return false;
  }
  
  func move() {
    self.zPosition = self.zPosition - self.speed
  }
  
  func move(withAdditionalDistance distance : CGFloat) {
    self.zPosition = self.zPosition - self.speed - distance
  }
  
  func isGone() -> Bool {
    return abs(zPosition) > GameScene.HORIZON
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
  
  private static func applyAllEffects(_ effects: [Effect], to game: GameScene) {
    for effect in effects {
      effect.apply(to: game)
    }
  }
  
}
