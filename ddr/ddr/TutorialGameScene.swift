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
  
  
  var actionInfo = SKLabelNode(fontNamed: "Chalkduster")
  
  var instructionNum = 0
  
  override func didMove(to view: SKView) {
    initializeBackground()
    
    initializeRider()
        
    beginSpawningBats()
  }
  
  func initializeBackground() {
    let background = SKSpriteNode(imageNamed: "background")
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: 0)
    background.zPosition = -999
    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / (GOLDEN_RATIO * 2);
    
    var tutorialText: SKLabelNode!
    tutorialText = SKLabelNode(fontNamed: "Chalkduster")
    tutorialText.text = "Tutorial"
    tutorialText.fontSize = 60
    tutorialText.fontColor = UIColor.white
    tutorialText.horizontalAlignmentMode = .right
    tutorialText.position = CGPoint(x: size.width/2 + 120, y: size.height - 60)
    
    actionInfo.lineBreakMode = NSLineBreakMode.byWordWrapping

    actionInfo.numberOfLines = 3

    actionInfo.preferredMaxLayoutWidth = THIRD_SCREEN_WIDTH
    
    addChild(background)
    addChild(tutorialText)
    addChild(actionInfo)
  }
  
  func initializeRider() {
    rider = Rider(audioManager: audioManager, motionManager: motionManager)
    addChild(rider!)
  }
  
  func beginSpawningBats() {
      let wait = SKAction.wait(forDuration: 5, withRange: 2)
      let spawn = SKAction.run {
        self.actionInfo.text = self.instructions[self.instructionNum]
        self.actionInfo.fontSize = 20
        self.actionInfo.fontColor = UIColor.white
        self.actionInfo.horizontalAlignmentMode = .right
        let offset = {self.instructionNum != 2 ? CGFloat(self.THIRD_SCREEN_WIDTH) : CGFloat(0)}
        self.actionInfo.position = CGPoint(x: (CGFloat(self.THIRD_SCREEN_WIDTH)*CGFloat(self.instructionNum) + offset()), y: self.size.height/2 - 20)
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
          let bat = Bat(audioManager: self.audioManager, pos: self.instructionNum)
          bat.isHidden = false // show the bats for the tutorial
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
    
    if (instructionNum == 3) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
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
