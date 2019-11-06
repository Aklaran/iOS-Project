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
  
  let THIRD_SCREEN_WIDTH = UIScreen.main.bounds.width / 3
  let GOLDEN_RATIO = CGFloat(1.61803398875)
  
  let maxLevels = 3
  
  let audioManager = AudioManager()
  let motionManager = CMMotionManager()
  
  var lives = [SKSpriteNode]();
  
  var bats = [Bat]()
  var rider: Rider? = nil
  
  override func didMove(to view: SKView) {
    initializeBackground()
    
    initializeRider()
    
    initializeHearts()
    
    beginSpawningBats()
  }
  
  func initializeBackground() {
    let background = SKSpriteNode(imageNamed: "background")
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: 0)
    background.zPosition = -999
    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / (GOLDEN_RATIO * 2);
    addChild(background)
  }
  
  func initializeRider() {
    rider = Rider(audioManager: audioManager, motionManager: motionManager)
    addChild(rider!)
  }
  
  func initializeHearts() {
    for i in 0 ..< rider!.lives {
      let newHeart = SKSpriteNode(imageNamed: "heart");
      newHeart.anchorPoint = (CGPoint(x: 0.5, y: 0.5))
      newHeart.position = CGPoint(x: CGFloat(50 + i * 100), y: (size.height - newHeart.size.height));
      lives.append(newHeart)
      addChild(newHeart)
    }
  }
  
  func beginSpawningBats() {
      let wait = SKAction.wait(forDuration: 5, withRange: 2)
      let spawn = SKAction.run {
        let bat = Bat(audioManager: self.audioManager)
        self.bats.append(bat)
        self.addChild(bat)
      }
      let sequence = SKAction.sequence([wait, spawn])
      // run(spawn) // for testing only generate one bat
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
    // Called before each frame is rendered
    
    guard let rider = rider else {
      print("No rider!")
      return
    }
    
    // clean-up obsolete bats
    var toRemove = [Bat]()
    for bat in bats {
      bat.move()
      
      if bat.z <= abs(bat.velocity) && bat.z >= -1 * abs(bat.velocity) {
      //if bat.z == 0 {
        checkCollision(bat: bat, rider: rider)
      }
      
      if bat.isGone() {
        toRemove.append(bat)
        bat.die()
      }
    }
    bats.removeAll(where: {
      toRemove.contains($0)
    })
  }
  
  func checkCollision(bat: Bat, rider: Rider) {
    let batThird = floor(bat.position.x / THIRD_SCREEN_WIDTH)
    let riderThird = floor(rider.x / THIRD_SCREEN_WIDTH)
    
    if batThird == riderThird {
      // decrement lives
      rider.loseLife()
      
      // update ui to reflect lost life
      let life = lives.popLast()
      life?.removeFromParent()
      
      // kill the bat too
      bat.hit()
      bat.die()
      bats.removeAll(where: { $0 == bat })
    }
    else {
      bat.pass()
    }
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
