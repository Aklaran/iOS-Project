//
//  Bat.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 10/31/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import UIKit
import SpriteKit

class Bat: Oncomer {
  
  static let WHOOSH_FILE = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  static let SPLAT_FILE = Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!
  static let FLAP_FILE = Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!
  static let FLAP_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 3 / 4
  
  let flapping: Emitter
  let whoosh: Emitter
  let splat: Emitter
  
  convenience init(spawner: Spawner<Oncomer>) {
    self.init(
      spawner: spawner,
      position: OncomerPosition.allCases.randomElement()!,
      speed: Bat.DEFAULT_SPEED
    )
  }
  
  init(spawner: Spawner<Oncomer>, position: OncomerPosition, speed: CGFloat) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat") // should be updated somehow whne bats are made to flap
    
    // start flapping
    flapping = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.FLAP_FILE, maxZMagnitude: GameScene.HORIZON)
    flapping.isRepeated = true
    flapping.speed = speed / Bat.FLAP_VELOCITY_CONVERSION
    flapping.start()
    
    // create emitters for whoosh and splat sounds
    whoosh = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.WHOOSH_FILE, maxZMagnitude: GameScene.HORIZON)
    whoosh.volume = 0.5
    whoosh.speed = 2
    splat = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.SPLAT_FILE, maxZMagnitude: GameScene.HORIZON)
    
    // init super vars
    super.init(
      spawner: spawner,
      emitters: [flapping, whoosh, splat],
      collisionEffects: [
        SoundEffect(emitter: splat),
        LoseLifeEffect()
      ],
      passEffects: [
        SoundEffect(emitter: whoosh)
      ],
      goneEffects: [],
      texture: texture,
      color: SKColor.clear,
      size: texture.size(),
      lightingBitMask: 0b0001
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
}
