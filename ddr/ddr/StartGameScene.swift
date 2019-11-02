//
//  StartGameScene.swift
//  ddr
//
//  Created by Matt Kern on 10/26/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import UIKit
import SpriteKit
import UIKit

class StartGameScene: SKScene {
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    let background = SKSpriteNode(imageNamed: "background")
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: 0)
    addChild(background)
    
    let startGameButton = SKSpriteNode(imageNamed: "start_btn")
    startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    startGameButton.name = "startgame"
    addChild(startGameButton)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "startgame" {
      let gameOverScene = GameScene(size: size)
      gameOverScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(gameOverScene,transition: transitionType)
    }
  }
  
}
