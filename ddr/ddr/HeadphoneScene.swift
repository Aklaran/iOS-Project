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
    
    let text1 = SKLabelNode()
    text1.text = "This is a hearing game!"
    text1.fontName = "PressStart2P-Regular"
    text1.fontSize = 16
    text1.horizontalAlignmentMode = .center
    text1.position = CGPoint(x: size.width/2, y: size.height/3 + 20)
    addChild(text1)
    
    let text2 = SKLabelNode()
    text2.text = "Make sure you have your headphones on in the right direction,"
    text2.fontName = "PressStart2P-Regular"
    text2.fontSize = 16
    text2.horizontalAlignmentMode = .center
    text2.position = CGPoint(x: size.width/2, y: size.height/3)
    addChild(text2)
    
    let text3 = SKLabelNode()
    text3.text = "then press OK to continue."
    text3.fontName = "PressStart2P-Regular"
    text3.fontSize = 16
    text3.horizontalAlignmentMode = .center
    text3.position = CGPoint(x: size.width/2, y: size.height/3 - 20)
    addChild(text3)
    
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
