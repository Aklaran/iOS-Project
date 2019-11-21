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
import AVFoundation

var levelNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
  /* Class Constants */
  // Game Facts
  static let FPS = 60
  static let WIDTH = UIScreen.main.bounds.width
  static let HEIGHT = UIScreen.main.bounds.height
  
  // Game Settings
  static let HORIZON : CGFloat = 100
  static let LEVELS: [Level] = [
    BoundedLevel(
      spawners: [
        try! Spawner(
          maxSpawned: 6,
          minSpawned: 5,
          maxConcurrent: 1,
          cooldown: 0.5,
          expectedDuration: 60,
          getNewSpawn: Bat.init)
      ],
      cartSpeed: 2
    )
  ]
  
  // Game Things
  static let AUDIO_MANAGER = AudioManager()
  
  /* Instance Variables */
  // Explict
  var oncomers: Set<Oncomer> = Set()
  var currentLevelIndex: Int = 0
  
  // Dynamic
  var currentLevel: Level {
    get {
      return GameScene.LEVELS[currentLevelIndex]
    }
  }
  
  /* ... eh ... */
  // not sure if these should stay...
  let THIRD_SCREEN_WIDTH = UIScreen.main.bounds.width / 3
  let GOLDEN_RATIO = CGFloat(1.61803398875)
  
  static let tracksSoundFile = Bundle.main.path(forResource: "tracks.mp3", ofType: nil)!
  
  let background:Background = Background()
  
  let maxLevels = 3
  var meters : CGFloat = 0 {
    didSet {
      progressLabel!.text = String(Int(meters)) + " meters"
    }
  }
  
  var velocity : CGFloat = 0.02
  
  
  let motionManager = CMMotionManager()
  
  var lives = [SKSpriteNode]();
  
//  var bats = [Bat]()
  var rider: Rider? = nil
  var progressLabel : SKLabelNode? = nil
  
  override func didMove(to view: SKView) {
    initializeBackground()
    
    initializeRider()
    
    initializeHearts()
    
    initializeSounds()
    
    initializeProgressFeedback()
    
//    beginSpawningBats()
  }
  
  func initializeProgressFeedback() {
    progressLabel = SKLabelNode(text: " meters")
    progressLabel?.position = CGPoint(
      x: UIScreen.main.bounds.width / 7 * 6,
      y: 9 * UIScreen.main.bounds.height / 10
    )
    addChild(progressLabel!)
  }
  
  func initializeSounds() {
    let tracksSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: GameScene.tracksSoundFile))
    tracksSound.numberOfLoops = -1
    tracksSound.volume = 0.05
    tracksSound.play()
    //tracksSound.numberOfLoops = -1
//    tracksSound.volume = 0.1
//    tracksSound.play()
    
//    var e = audioManager.createEmitter(soundFile: GameScene.tracksSoundFile, maxZMagnitude: 10)
////    e = Emitter(soundFile: GameScene.tracksSoundFile, maxZMagnitude: 10)
//    e.isRepeated = true
//    e.volume = 0.05
//    e.start()
//    e.updatePosition(rider!.position)
    
  }
  
  func initializeBackground() {
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: 0)
    background.zPosition = -999
    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / (GOLDEN_RATIO * 2);
    addChild(background)
    background.isHidden = true // no sight by default
  }
  
  func initializeRider() {
    rider = Rider(audioManager: GameScene.AUDIO_MANAGER, motionManager: motionManager)
    addChild(rider!)
    rider?.isHidden = true // no sight by default
  }
  
  func initializeHearts() {
    for i in 0 ..< rider!.lives {
      let newHeart = SKSpriteNode(imageNamed: "heart");
      newHeart.anchorPoint = (CGPoint(x: 0.5, y: 0.5))
      newHeart.position = CGPoint(x: CGFloat(newHeart.size.width/2 + CGFloat(i) * 100), y: (size.height - newHeart.size.height));
      lives.append(newHeart)
      addChild(newHeart)
    }
  }
  
//  func beginSpawningBats() {
//      let wait = SKAction.wait(forDuration: 2, withRange: 2)
//      let spawn = SKAction.run {
//        let bat = Bat(audioManager: GameScene.AUDIO_MANAGER, pos: nil, hide: nil)
//        self.bats.append(bat)
//        self.addChild(bat)
//      }
//      let sequence = SKAction.sequence([wait, spawn])
//      // run(spawn) // for testing only generate one bat
//      run(SKAction.repeatForever(sequence))
//  }
  
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
//    rider!.position = touches.first?.location(in: self) as! CGPoint
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    guard let rider = rider else {
      print("No rider!")
      return
    }
    
    // for each oncomer
    for oncomer in oncomers {
      
      // move forward
      oncomer.move(withAdditionalDistance: currentLevel.getCartSpeed())
      
      // check collisions
      if withinStrikingDistance(of: oncomer) {
        if oncomer.collidesWith(node: rider) {
          oncomer.applyGoneEffects(to: self)
        } else {
          oncomer.applyPassEffects(to: self)
        }
      }
      
      // check if gone
      if oncomer.isGone() {
        oncomer.applyGoneEffects(to: self)
      }
      
    }
    
    // get anything newly spawned
    let newOncomers = currentLevel.spawn()
    oncomers = oncomers.union(newOncomers)
    for oncomer in newOncomers {
      addChild(oncomer)
    }
    
    
    
    // clean-up obsolete bats
//    var toRemove = [Bat]()
//    for bat in bats {
//      bat.move()
//
//      if bat.z <= abs(bat.velocity) && bat.z >= -1 * abs(bat.velocity) {
//        checkCollision(bat: bat, rider: rider)
//      }
//
//      if bat.isGone() {
//        toRemove.append(bat)
//        bat.die()
//      }
//    }
//    bats.removeAll(where: {
//      toRemove.contains($0)
//    })
    
    // move the cart
    meters = meters + velocity
    
  }
  
//  func checkCollision(bat: Bat, rider: Rider) {
//    let batThird = floor(bat.position.x / THIRD_SCREEN_WIDTH)
//    let riderThird = floor(rider.x / THIRD_SCREEN_WIDTH)
//
//    if batThird == riderThird {
//      // decrement lives
//      rider.loseLife()
//
//      // update ui to reflect lost life
//      let life = lives.popLast()
//      life?.removeFromParent()
//
//      // kill the bat too
//      bat.hit()
//      bat.die()
//      bats.removeAll(where: { $0 == bat })
//
//      // check game over
//      if rider.isDead() {
//        endGame()
//
//        // kill all the bats
//        for bat in bats {
//          bat.die()
//        }
//        bats = []
//      }
//    }
//    else {
//      bat.pass()
//    }
//  }
  
  // MARK: - Game Management Methods
  func levelComplete() {
    if(levelNum <= maxLevels){
    } else {
      levelNum = 1
      ()
    }
  }
  
  func endGame() {
    let gameOverScene = GameOverScene(size: size)
    gameOverScene.scaleMode = scaleMode
    
    gameOverScene.distance = meters // pass distance traveled for the leaderboard

    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  func newGame() {
    let gameOverScene = StartGameScene(size: size)
    gameOverScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  private func withinStrikingDistance(of node: SKNode) -> Bool {
    return abs(node.zPosition) <= node.speed + currentLevel.getCartSpeed()
  }
}
