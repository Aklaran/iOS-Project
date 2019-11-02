//
//  StartGameScene.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 10/26/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import UIKit
import SpriteKit
import UIKit

class StartGameScene: SKScene {
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    
    let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
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
