
import Foundation
import SpriteKit

class Oncomer: SKSpriteNode, Spawnable {
  
  let spawner: Spawner<Oncomer>
  let emitters: [Emitter]
  var collisionEffects: [Effect]
  var passEffects: [Effect]
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
    size: CGSize,
    lightingBitMask: UInt32)
  {
    self.spawner = spawner
    self.collisionEffects = collisionEffects
    self.passEffects = passEffects
    self.goneEffects = goneEffects
    self.emitters = emitters
    super.init(texture: texture, color: color, size: size)
    super.lightingBitMask = lightingBitMask
    self.collisionEffects = self.collisionEffects + [ KillOncomerEffect(oncomer: self) ]
    self.passEffects = self.passEffects + [ HideEffect(nodeToHide: self) ]
    self.goneEffects = self.goneEffects + [ KillOncomerEffect(oncomer: self) ]
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
  
  func collidesWith(position: CGPoint) -> Bool {
    return false
  }
  
//  could not use because rider headPosition != rider position
//  func collidesWith(node: SKNode) -> Bool {
//    return collidesWith(position: node.position)
//  }
  
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
