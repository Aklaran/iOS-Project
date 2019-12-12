//
//  HeadphoneScene.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 12/12/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class HeadphoneScene: SKScene {
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)

    let headphones = SKSpriteNode(imageNamed: "headphone_outline")
    headphones.position = CGPoint(x: size.width/2, y: size.height * (2/3))
    headphones.name = "headphones"
    addChild(headphones)
    
    let text = "This is a hearing game!\nMake sure you have your headphones on\nin the right orientation,\nthen press OK to continue."
    let headphoneLabel = MultilineLabel(text: text)
    
    headphoneLabel.fontName = "PressStart2P-Regular"
    headphoneLabel.fontSize = 16
    headphoneLabel.position = CGPoint(x: size.width/2, y: size.height/3)
    headphoneLabel.parentToScene(scene: self)

    let okButton = SKSpriteNode(imageNamed: "ok_button")
    okButton.position = CGPoint(x: size.width/2, y: size.height/8)
    okButton.name = "ok"
    okButton.zPosition = 1
    addChild(okButton)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "ok" {
      let newgameScene = GameScene(size: size)
      newgameScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(newgameScene,transition: transitionType)
    }
  }
  
}
