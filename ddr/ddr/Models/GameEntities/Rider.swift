//
//  Rider.swift
//  Space Destgroyers
//
//  Created by Siri  Tembunkiart on 11/2/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class Rider: SKSpriteNode {
  static let HALF_SCREEN_WIDTH = UIScreen.main.bounds.width / 2
  
  let audioManager : AudioManager?
  let motionManager : CMMotionManager?
  
  let flashlight : Flashlight?
  
  let z : CGFloat = 0
  
  var headPosition: CGPoint {
    didSet {
      audioManager?.updateListenerPosition(to: position)
    }
  }
  
  private var invincible = false
  
  var lives:Int = 3
  
  init(audioManager: AudioManager, motionManager: CMMotionManager, flashlight: Flashlight) {
    let texture = SKTexture(imageNamed: "rider")
    
    self.audioManager = audioManager
    self.motionManager = motionManager
    self.headPosition = CGPoint(x: 0, y: 0) // will be changed later
    self.flashlight = flashlight
    
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    self.setScale(0.4)
    self.headPosition = CGPoint(x: GameScene.WIDTH / 2, y: position.y)
    self.position.x = Rider.HALF_SCREEN_WIDTH
    self.position.y = 0
    self.anchorPoint = CGPoint(x: 0.5, y: 0)
    
    self.flashlight?.categoryBitMask = 0b0001
    self.flashlight?.lightColor = .white
    addChild(self.flashlight!)
    
    beginMotionUpdates()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }
  
  func loseLife() {
    if (!invincible) {
      lives -= 1
    }
  }
  
  func isDead() -> Bool {
    return lives <= 0
  }
  
  func respawn(){
    // logic to be determined shortly
    invincible = true
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.4)
    let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
    let fadeOutIn = SKAction.sequence([fadeOutAction,fadeInAction])
    let fadeOutInAction = SKAction.repeat(fadeOutIn, count: 3)
    let setInvicibleFalse = SKAction.run(){
      self.invincible = false
    }
    run(SKAction.sequence([fadeOutInAction,setInvicibleFalse]))
  }

// MARK: - Sprite/Visual Functionality
  
  func rotate(rotationMultiplier:CGFloat) {
    self.zRotation = CGFloat(-Double.pi) * rotationMultiplier * 0.5
  }
  
// MARK: - Core Motion

  func beginMotionUpdates() {
    let queue = OperationQueue()

    guard let motionManager = motionManager else {
      print("Motion Manager unavailable")
      return
    }

    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
        guard let data = data, error == nil else {
          print("Motion data unavailable")
          return
        }
        
        // FIXME: rotation only works for 1 orientation (home button left)
        let rotation = CGFloat(data.gravity.y)

        // playerPosition for collision calculations
        // spritePosition for spritenode updates
        let playerPosition = Rider.HALF_SCREEN_WIDTH + (rotation * Rider.HALF_SCREEN_WIDTH)
        let spritePosition = Rider.HALF_SCREEN_WIDTH + ((rotation / 2) * Rider.HALF_SCREEN_WIDTH)
        DispatchQueue.main.async {
          
          // collision var updates
          self?.headPosition.x = playerPosition
          // self?.lightNode?.position.x = playerPosition
          
          // spriteNode updates
          self?.position.x = spritePosition
          self?.rotate(rotationMultiplier: rotation)
        }
      }
    }
  }
}
