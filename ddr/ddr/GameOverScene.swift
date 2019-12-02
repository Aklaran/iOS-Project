//
//  GameOverScene.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 11/7/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameOverScene: SKScene {
  
  var score: CGFloat?

  override func didMove(to view: SKView) {
    backgroundColor = SKColor(red:0.00, green:0.59, blue:0.63, alpha:1.0)

    let progressLabel = SKLabelNode(text: "You made it " + String(Int(score!)) + " meters")
    progressLabel.position = CGPoint(x: size.width/2, y: size.height - size.height / 1.618)
    addChild(progressLabel)
    
    let restartButton = SKSpriteNode(imageNamed: "restart_btn")
    restartButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    restartButton.name = "restartgame"
    addChild(restartButton)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "restartgame" {
      let newGameScene = GameScene(size: size)
      newGameScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(newGameScene,transition: transitionType)
    }
  }

}
