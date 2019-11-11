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

//var levelNum = 1

class TutorialGameScene: SKScene, SKPhysicsContactDelegate {
  
  let THIRD_SCREEN_WIDTH = UIScreen.main.bounds.width / 3
  let GOLDEN_RATIO = CGFloat(1.61803398875)
  
  let maxLevels = 3
  
  let background:Background = Background()

  
  let audioManager = AudioManager()
  let motionManager = CMMotionManager()
  
  var lives = [SKSpriteNode]();
  
  var bats = [Bat]()
  var rider: Rider? = nil
  
  var instructions = [
    "Dodge bats by tilting your phone the other way! This one's coming up on the left, swing right!",
    "Watch out, sometimes they come from the front!",
    "Last one!"
  ]
  
  var sceneEnded = false
  
  var actionInfo = SKLabelNode(fontNamed: "Chalkduster")
  
  var instructionNum = 0
  
  var tutorialTitleText: SKLabelNode!
  var tutorialSubText: SKLabelNode!
  
  let startTutorialButton = SKSpriteNode(imageNamed: "start_btn")
  
  
  override func didMove(to view: SKView) {
    initializeBackground()
    
    initializeRider()
  }
  
  func initializeBackground() {
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.zPosition = -999
    background.position = CGPoint(x: size.width/2, y: 0)    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / (GOLDEN_RATIO * 2);
    
    addChild(background)
    
    tutorialTitleText = SKLabelNode(fontNamed: "Chalkduster")
    tutorialTitleText.text = "Tutorial"
    tutorialTitleText.fontSize = 60
    tutorialTitleText.fontColor = UIColor.white
    tutorialTitleText.horizontalAlignmentMode = .right
    tutorialTitleText.position = CGPoint(x: size.width/2 + 120, y: size.height - 60)
    
    tutorialSubText = SKLabelNode(fontNamed: "Chalkduster")
    tutorialSubText.text = "This is a sensory game. Use your ears to guide you through a mineshaft, and tilt your phone to dodge bats coming your way. See how far you can make it! You'll see bats in the tutorial, but in the real game, it'll be too dark to use your eyes!"
    tutorialSubText.fontSize = 20
    tutorialSubText.fontColor = UIColor.white
    tutorialSubText.verticalAlignmentMode = .center
    tutorialSubText.horizontalAlignmentMode = .center
    tutorialSubText.position = CGPoint(x: size.width/2, y: size.height/2)
    
    tutorialSubText.lineBreakMode = NSLineBreakMode.byWordWrapping

    tutorialSubText.numberOfLines = 3

    tutorialSubText.preferredMaxLayoutWidth = THIRD_SCREEN_WIDTH * 1.5

    startTutorialButton.position = CGPoint(x: self.size.width - self.size.width/4, y: 50)
    startTutorialButton.name = "next"
    startTutorialButton.zPosition = 1000
    
    actionInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
    actionInfo.numberOfLines = 3
    actionInfo.preferredMaxLayoutWidth = THIRD_SCREEN_WIDTH
    
    addChild(tutorialTitleText)
    addChild(actionInfo)
    addChild(tutorialSubText)
    addChild(startTutorialButton)
  }
  
  func initializeRider() {
    rider = Rider(audioManager: audioManager, motionManager: motionManager)
    addChild(rider!)
  }
  
  func beginSpawningBats() {
      let wait = SKAction.wait(forDuration: 5)
      let spawn = SKAction.run {
        self.actionInfo.text = self.instructions[self.instructionNum]
        self.actionInfo.fontSize = 20
        self.actionInfo.fontColor = UIColor.white
        self.actionInfo.horizontalAlignmentMode = .right
        let offset = {self.instructionNum != 2 ? CGFloat(self.THIRD_SCREEN_WIDTH) : CGFloat(0)}
        self.actionInfo.position = CGPoint(x: (CGFloat(self.THIRD_SCREEN_WIDTH)*CGFloat(self.instructionNum) + offset()), y: self.size.height/2 - 20)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
          let bat = Bat(audioManager: self.audioManager, pos: self.instructionNum, hide: false)

          self.bats.append(bat)
          self.addChild(bat)
          self.instructionNum += 1;
          self.actionInfo.text = ""
        }
      
      }
      let repeatAction = SKAction.repeat(SKAction.sequence([wait,spawn]), count: instructions.count)

      self.run(repeatAction)
    }

  func touchDown(atPoint pos : CGPoint) {
    
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    
  }
  
  func touchUp(atPoint pos : CGPoint) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "startgame" {
      let newGameScene = GameScene(size: size)
      newGameScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(newGameScene,transition: transitionType)
    }
    
    else if touchedNode.name == "next" {
      print("we got it")
      tutorialSubText.removeFromParent()
      tutorialSubText.removeFromParent()
      startTutorialButton.removeFromParent()
      beginSpawningBats()

    }
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
    
    if (instructionNum == 3 && sceneEnded == false) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
        self.sceneEnded = true;
        let startGameButton = SKSpriteNode(imageNamed: "start_btn")
        startGameButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 100)
        startGameButton.name = "startgame"
        startGameButton.zPosition = 1000
        self.addChild(startGameButton)
      }
    }
    
    guard let rider = rider else {
      print("No rider!")
      return
    }
    
    // clean-up obsolete bats
    var toRemove = [Bat]()
    for bat in bats {
      bat.move()
      
      if bat.z <= abs(bat.velocity) && bat.z >= -1 * abs(bat.velocity) {
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
      // don't decrement lives in tutorial, but show the flashing
      rider.respawn()
      
      // update ui to reflect lost life
      // let life = lives.popLast()
      // life?.removeFromParent()
      
      // kill the bat tho
      bat.hit()
      bat.die()
      bats.removeAll(where: { $0 == bat })
      
      // check game over
      if rider.isDead() {
        let gameOverScene = StartGameScene(size: self.scene!.size)
        gameOverScene.scaleMode = self.scene!.scaleMode
        let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
        self.scene!.view!.presentScene(gameOverScene,transition: transitionType)
        
        // kill all the bats
        for bat in bats {
          bat.die()
        }
        bats = []
      }
    }
    else {
      bat.pass()
    }
  }
}
