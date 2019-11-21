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
    backgroundColor = SKColor(red:0.00, green:0.59, blue:0.63, alpha:1.0)

    let backgroundPicture = SKSpriteNode(imageNamed: "ddr")
    backgroundPicture.anchorPoint = CGPoint(x: 0.5, y: 0.5);
    backgroundPicture.position = CGPoint(x: size.width/2, y: size.height - backgroundPicture.size.height)

    addChild(backgroundPicture)
    
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
      let newGameScene = GameScene(size: size)
      newGameScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(newGameScene,transition: transitionType)
    }
  }
  
}
