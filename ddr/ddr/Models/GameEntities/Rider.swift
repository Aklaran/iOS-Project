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
  
  let audioManager: AudioManager?
  let motionManager: CMMotionManager?
  
  private var invincible = false
  
  override var position: CGPoint {
    didSet {
      audioManager?.updateListenerPosition(to: position)
    }
  }
  
  private var lives:Int = 3 {
    didSet {
      if (lives < 0) {
        loseGame()
      } else {
        respawn()
      }
    }
  }
  
  init(audioManager: AudioManager, motionManager: CMMotionManager) {
    let texture = SKTexture(imageNamed: "profH")
    
    self.audioManager = audioManager
    self.motionManager = motionManager
    
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    self.setScale(0.4)
    self.position.x = Rider.HALF_SCREEN_WIDTH
    
    beginMotionUpdates()
    // preparing player for collisions once we add physics...
  }
  
  required init?(coder aDecoder: NSCoder) {
    audioManager = nil
    motionManager = nil
    
    super.init(coder: aDecoder)
  }
  
  func loseLife() {
    // logic to be determined shortly
    if (!invincible) {
      lives -= 1
    }
  }
  
  func loseGame(){
    // logic to be determined shortly
    let gameOverScene = StartGameScene(size: self.scene!.size)
    gameOverScene.scaleMode = self.scene!.scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    self.scene!.view!.presentScene(gameOverScene,transition: transitionType)
  }
  
  func respawn(){
    // logic to be determined shortly
    invincible = true
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.4)
    let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
    let fadeOutIn = SKAction.sequence([fadeOutAction,fadeInAction])
    let fadeOutInAction = SKAction.repeat(fadeOutIn, count: 5)
    let setInvicibleFalse = SKAction.run(){
      self.invincible = false
    }
    run(SKAction.sequence([fadeOutInAction,setInvicibleFalse]))
  }

// MARK: - Sprite/Visual Functionality
  
  //Zrotation starts at 0.0 and rotates counter clockwise
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

        let playerPosition = Rider.HALF_SCREEN_WIDTH + ((rotation / 2) * Rider.HALF_SCREEN_WIDTH)
        DispatchQueue.main.async {
          self?.position.x = playerPosition
          self?.rotate(rotationMultiplier: rotation)
        }
      }
    }
  }
}