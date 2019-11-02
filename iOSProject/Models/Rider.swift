//
//  Rider.swift
//  Space Destgroyers
//
//  Created by Siri  Tembunkiart on 11/2/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import Foundation
import SpriteKit

class Rider: SKSpriteNode {
  private var invincible = false
  let audioManager: AudioManager?
  
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
  
  init(audioManager: AudioManager) {
    let texture = SKTexture(imageNamed: "player1")
    self.audioManager = audioManager
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    // preparing player for collisions once we add physics...
  }
  
  required init?(coder aDecoder: NSCoder) {
    audioManager = nil
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
  
  //Zrotation starts at 0.0 and rotates counter clockwise
  func rotate(playerPosition:CGFloat) {
    let width = CGFloat(UIScreen.main.bounds.width);
    var angle:Float
    let rightBounds = 3.14 / 2
    let leftBounds = -3.14 / 2
    print("PLAYER POSITION IS", playerPosition)
    print("WIDTH IS", width)
    if (playerPosition >= width / 2) {
      angle = Float((playerPosition - width/2) * CGFloat(rightBounds))
    }
    else {
      angle = Float((width/2 - playerPosition) * CGFloat(leftBounds))
    }
    
    self.zRotation = CGFloat(angle);
  }

  
  
}
