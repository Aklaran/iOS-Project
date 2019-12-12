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
  
  let playerData = PlayerData.singleton
  
  var score: CGFloat?

  override func didMove(to view: SKView) {
    backgroundColor = SKColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)
    
    presentScore((Int(score!)))
    
    let restartButton = SKSpriteNode(imageNamed: "start_over_btn")
    restartButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    restartButton.position = CGPoint(x: size.width/2, y: size.height/2)
    restartButton.name = "restartgame"
    addChild(restartButton)
    
    let resetButton = SKSpriteNode(imageNamed: "reset")
    resetButton.anchorPoint = CGPoint(x: 1, y: 0)
    resetButton.position = CGPoint(x: size.width, y: 0)
    resetButton.name = "reset"
    resetButton.zPosition = 1
    resetButton.size = CGSize(width: 75, height: 50)
    addChild(resetButton)
  }
  
  func presentScore(_ value: Int) {
    let highScore = playerData.getHighScore()
    
    if value > highScore {
      createNewHighScoreLabel(for: value)
      playerData.setHighScore(to: value)
    } else {
      createHighScoreLabel(for: highScore)
      createScoreLabel(for: value)
    }
  }
  
  func createNewHighScoreLabel(for value: Int) {
    let newHighScoreLabel = SKLabelNode(text: "NEW HIGH SCORE: \(value) POINTS!")
    newHighScoreLabel.fontName = "PressStart2P-Regular"
    newHighScoreLabel.position = CGPoint(x: size.width/2, y: size.height / 2 - 200)
    addChild(newHighScoreLabel)
  }
  
  func createHighScoreLabel(for value: Int) {
    let highScoreLabel = SKLabelNode(text: "High score: \(value) points")
    highScoreLabel.fontName = "PressStart2P-Regular"
    highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
    addChild(highScoreLabel)
  }

  func createScoreLabel(for value: Int) {
    let progressLabel = SKLabelNode(text: "You got \(value) points!")
    progressLabel.fontName = "PressStart2P-Regular"
    progressLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 200)
    addChild(progressLabel)
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
    
    else if touchedNode.name == "reset" {
      showResetAlert()
    }
  }
  
  func showResetAlert() {
    let alert = UIAlertController(title: "Reset Progress?", message: "This will reset your progress through the tutorial levels. Your highscore will not be affected.", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
    }))
    
    alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: {(_: UIAlertAction!) in
        PlayerData.singleton.resetTrainingsSeen()
    }))
    
    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
  }

}
