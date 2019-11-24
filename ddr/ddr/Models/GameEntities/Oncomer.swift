
import Foundation
import SpriteKit

enum OncomerPosition: Int, CaseIterable {
  case LEFT = 0
  case MIDDLE = 1
  case RIGHT = 2
  
  func getX() -> CGFloat{
    return (CGFloat(self.rawValue) * (GameScene.WIDTH / 3)) + CGFloat(GameScene.WIDTH / 6)
  }
  
  static func of(x: CGFloat) -> OncomerPosition {
    return OncomerPosition(rawValue: Int(x / (GameScene.WIDTH / 3)))!
  }
  
}

class Oncomer: SKSpriteNode, Spawnable {
  
  let spawner: Spawner<Oncomer>
  let emitters: [Emitter]
  var collisionEffects: [Effect]
  var passEffects: [Effect]
  var goneEffects: [Effect]
  
  var collisionThird: Int
  
  override var zPosition: CGFloat {
    didSet {
      // update sound
      emitters.forEach({ $0.updateZ(zPosition) })
      
      // progress from horizon to player in (0, 1)
      let zProgress = (GameScene.HORIZON  - abs(zPosition)) / GameScene.HORIZON
      
      // update visual - scale
      xScale =  zProgress
      yScale = xScale
      
      // update visual - screen position
      // oncomers move from vanishing pt in middle of screen
      // and progress to either edge of screen or the middle
      let modifier = 1 + CGFloat(self.collisionThird - 1) * zProgress
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
    spawner: Spawner<Oncomer>,
    emitters: [Emitter],
    collisionEffects: [Effect],
    passEffects: [Effect],
    goneEffects: [Effect],
    texture: SKTexture?,
    color: UIColor,
    size: CGSize,
    lightingBitMask: UInt32,
    collisionThird: Int)
  {
    self.spawner = spawner
    self.collisionEffects = collisionEffects
    self.passEffects = passEffects
    self.goneEffects = goneEffects
    self.emitters = emitters
    self.collisionThird = collisionThird
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
    return OncomerPosition.of(x: self.position.x) == OncomerPosition.of(x: position.x)
  }
  
//  could not use because rider headPosition != rider position
//  func collidesWith(node: SKNode) -> Bool {
//    return collidesWith(position: node.position)
//  }
  
  func move(withAdditionalDistance distance : CGFloat = 0) {
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
