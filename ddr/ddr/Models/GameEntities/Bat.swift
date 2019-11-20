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
}

class Bat: Oncomer, Spawnable {
//  static let SCREEN_HEIGHT = UIScreen.main.bounds.height
//  static let SIXTH_SCREEN_WIDTH = UIScreen.main.bounds.width / 6
  static let SWOOSH_FILE = Bundle.main.path(forResource: "swoosh.mp3", ofType: nil)!
  static let FLAP_FILE = Bundle.main.path(forResource: "singleFlap.mp3", ofType: nil)!
  
  // Bat Constants
//  static let maxZMagnitude : CGFloat = 100
  static let FLAP_VELOCITY_CONVERSION: CGFloat = 1
  static let DEFAULT_SPEED: CGFloat = 1.5
  static let DEFAULT_Y: CGFloat = GameScene.HEIGHT * 3 / 4
  
  // instance vars
//  var velocity : CGFloat = -1.5
//  let audioManager : AudioManager
  let flapping: Emitter
  
  override var zPosition: CGFloat {
    didSet {
      // update sound
      flapping.updateZ(zPosition)
      
      // update visual
      xScale = (GameScene.HORIZON - abs(zPosition)) / GameScene.HORIZON
      yScale = xScale
    }
  }
  
  // override to update emitter(s)
  override var position : CGPoint {
    didSet {
      flapping.updatePosition(position)
    }
  }
  
  convenience init(spawner: Spawner<Bat>) {
    self.init(
      spawner: spawner,
      position: BatPosition.allCases.randomElement()!,
      speed: Bat.DEFAULT_SPEED
    )
  }
  
  init(spawner: Spawner<Bat>, position: BatPosition, speed: CGFloat) {
    // my instance vars
    let texture = SKTexture(imageNamed: "bat") // should be updated somehow whne bats are made to flap
    
    flapping = GameScene.AUDIO_MANAGER.createEmitter(soundFile: Bat.FLAP_FILE, maxZMagnitude: GameScene.HORIZON)
    flapping.isRepeated = true
    flapping.speed = speed / Bat.FLAP_VELOCITY_CONVERSION
    zPosition = GameScene.HORIZON
    flapping.start()
    
    let foo : Oncomer = self as Oncomer
    
    // init super vars
    super.init(spawner: spawner as Spawner<Oncomer>, texture: texture, color: SKColor.clear, size: texture.size())
    
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
  
  func hit() {
    isHidden = true
    // play sound to hit the player
    let hitSound = audioManager.createEmitter(soundFile: Bundle.main.path(forResource: "impact-kick.wav", ofType: nil)!, maxZMagnitude: Bat.maxZMagnitude)
    hitSound.updatePosition(self.position)
    hitSound.start()
  }
  
  func pass() {
    isHidden = true
    // play whoosh sound to pass the player
    let whooshSound = audioManager.createEmitter(soundFile: Bat.swooshFile, maxZMagnitude: Bat.maxZMagnitude)
    whooshSound.updatePosition(self.position)
    whooshSound.volume = 0.3
    whooshSound.speed = 2
    whooshSound.start()
  }
  
}
