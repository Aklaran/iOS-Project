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
    backgroundColor = SKColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)

    let backgroundPicture = SKSpriteNode(imageNamed: "start_background")
    backgroundPicture.size = CGSize(width: size.width, height: size.height)
    backgroundPicture.anchorPoint = CGPoint(x: 0.5, y: 0.5);
    backgroundPicture.position = CGPoint(x: size.width/2, y: size.height/2)
    backgroundPicture.zPosition = 0
    addChild(backgroundPicture)
    
    let startGameButton = SKSpriteNode(imageNamed: "start_btn_new")
    startGameButton.anchorPoint = CGPoint(x: 1, y: 0.5);
    startGameButton.position = CGPoint(x: size.width/3 + 100, y: size.height/2 - 100)
    startGameButton.name = "startgame"
    startGameButton.zPosition = 1
    addChild(startGameButton)
    
    let comingSoonButton = SKSpriteNode(imageNamed: "coming_soon")
    comingSoonButton.anchorPoint = CGPoint(x: 0, y: 0.5);
    comingSoonButton.position = CGPoint(x: 2*size.width/3 - 100, y: size.height/2 - 100)
    comingSoonButton.name = "coming soon"
    comingSoonButton.zPosition = 1
    addChild(comingSoonButton)
    
    let resetButton = SKSpriteNode(imageNamed: "reset")
    resetButton.anchorPoint = CGPoint(x: 1, y: 0)
    resetButton.position = CGPoint(x: size.width, y: 0)
    resetButton.name = "reset"
    resetButton.zPosition = 1
    resetButton.size = CGSize(width: 75, height: 50)
    addChild(resetButton)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    
    if touchedNode.name == "startgame" {
      let headphoneScene = HeadphoneScene(size: size)
      headphoneScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(headphoneScene,transition: transitionType)
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
