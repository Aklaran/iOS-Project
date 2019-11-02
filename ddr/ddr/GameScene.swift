//
//  GameScene.swift
//  ddr
//
//  Created by Matt Kern on 10/26/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

var levelNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let maxLevels = 3
  
  let initialBatZ: CGFloat = 100
  let finalBatZ: CGFloat = -100
  
  let audioManager = AudioManager()
  let motionManager = CMMotionManager()
  
  var bat : Bat? = nil
  var bats : [Bat] = [Bat]()
  
  var rider: Rider? = nil
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    
    rider = Rider(audioManager: audioManager, motionManager: motionManager)
    addChild(rider!)
    
    // for spawning the bats
    let wait = SKAction.wait(forDuration: 3, withRange: 2)
    let spawn = SKAction.run {
      let bat = Bat(audioManager: self.audioManager)
      bat.z = self.initialBatZ
      self.bats.append(bat)
      self.addChild(bat)
    }
    let sequence = SKAction.sequence([wait, spawn])
    run(SKAction.repeatForever(sequence))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    
  }
  
  func touchUp(atPoint pos : CGPoint) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    rider!.position = touches.first?.location(in: self) as! CGPoint
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func update(_ currentTime: TimeInterval) {
    // // Called before each frame is rendered
    //    if (lastSpawnTime == nil || lastSpawnTime! - currentTime > 5) {
    //      print("spawning")
    //      lastSpawnTime = currentTime
    //    }
    //    else {
    //    }
  }
  
  // MARK: - Game Management Methods
  func levelComplete(){
    if(levelNum <= maxLevels){
    } else {
      levelNum = 1
      newGame()
    }
  }
  
  func newGame(){
    let gameOverScene = StartGameScene(size: size)
    gameOverScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
}