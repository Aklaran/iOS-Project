//
//  Bat.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 10/31/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import UIKit
import SpriteKit

enum BatPosition: Int, CaseIterable {
  case LEFT = 0
  case MIDDLE = 1
  case RIGHT = 2
  
  func getX() -> CGFloat{
    return (CGFloat(self.rawValue) * (GameScene.WIDTH / 3)) + CGFloat(GameScene.WIDTH / 6)
  }
  
  static func of(x: CGFloat) -> BatPosition {
    return BatPosition(rawValue: min(max(0, Int(GameScene.WIDTH / x)), 2))!
  }
  
}

class Bat: Oncomer {
  
  static let SWOOSH_FILE = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  static let FLAP_FILE = Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!
  static let FLAP_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1.5
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 3 / 4
  
  let flapping: Emitter
  
  convenience init(spawner: Spawner<Oncomer>) {
    self.init(
      spawner: spawner,
      position: BatPosition.allCases.randomElement()!,
      speed: Bat.DEFAULT_SPEED
    )
  }
  
  init(spawner: Spawner<Oncomer>, position: BatPosition, speed: CGFloat) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat") // should be updated somehow whne bats are made to flap
    
    // start flapping
    flapping = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.FLAP_FILE, maxZMagnitude: GameScene.HORIZON)
    flapping.isRepeated = true
    flapping.speed = speed / Bat.FLAP_VELOCITY_CONVERSION
    flapping.start()
    
    // init super vars
    super.init(
      spawner: spawner,
      emitters: [flapping],
      collisionEffects: [], // todo: add these
      passEffects: [], // todo: add these
      goneEffects: [],
      texture: texture,
      color: SKColor.clear,
      size: texture.size()
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
  
  override func collidesWith(node: SKNode) -> Bool {
    return BatPosition.of(x: position.x) == BatPosition.of(x: node.position.x)
  }
  
//  func hit() {
//    isHidden = true
//    // play sound to hit the player
//    let hitSound = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!, maxZMagnitude: Bat.maxZMagnitude)
//    hitSound.updatePosition(self.position)
//    hitSound.start()
//  }
  
//  func pass() {
//    isHidden = true
//    // play whoosh sound to pass the player
//    let whooshSound = audioManager.createEmitter(soundFile: Bat.swooshFile, maxZMagnitude: Bat.maxZMagnitude)
//    whooshSound.updatePosition(self.position)
//    whooshSound.volume = 0.3
//    whooshSound.speed = 2
//    whooshSound.start()
//  }
  
}
