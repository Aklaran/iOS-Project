//
//  TutorialImage.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 11/11/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialImage: SKSpriteNode {
  static let SCREEN_HEIGHT = UIScreen.main.bounds.height
  static let SIXTH_SCREEN_WIDTH = UIScreen.main.bounds.width / 6
  
  let rotationDegrees = 45 // positive value rotates counterclockwise
  let rotationDuration = 0.5
  let waitDuration = 0.5
  
  init(third: Int, rotateRight: Bool = false, alternate: Bool = false) {
    // rotateRight param decides texture and args to rotation fn
    let texture = rotateRight ? SKTexture(imageNamed: "rotate_right") : SKTexture(imageNamed: "rotate_left")
    
    // init super vars
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    
    // janky scale adjustment cuz idk how image importing works
    setScale(0.25)
    
    position = CGPoint(
      x: TutorialImage.SIXTH_SCREEN_WIDTH + (2 * CGFloat(third) * TutorialImage.SIXTH_SCREEN_WIDTH),
      y: UIScreen.main.bounds.height / 2
    )
    
    // alternate overrides right rotation
    if alternate {
      beginAlternatingRotation()
    } else {
      beginRotation(rotateRight: rotateRight)
    }
  }
  
  // annoying but required - doing the minimum to compile
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func beginAlternatingRotation() {
    let useLeftImage = SKAction.setTexture(SKTexture(imageNamed: "rotate_left"))
    let rotateLeft = SKAction.rotate(byAngle: deg2rad(rotationDegrees), duration: rotationDuration)
    let resetLeft = SKAction.rotate(byAngle: deg2rad(-rotationDegrees), duration: 0)

    let wait = SKAction.wait(forDuration: waitDuration)
    
    let useRightImage = SKAction.setTexture(SKTexture(imageNamed: "rotate_right"))
    let rotateRight = SKAction.rotate(byAngle: deg2rad(-rotationDegrees), duration: rotationDuration)
    let resetRight = SKAction.rotate(byAngle: deg2rad(rotationDegrees), duration: 0)
    
    let sequence = SKAction.sequence([useLeftImage, rotateLeft, wait, resetLeft,
                                      useRightImage, rotateRight, wait, resetRight])
    
    run(SKAction.repeatForever(sequence))
  }
  
  func beginRotation(rotateRight: Bool) {
    // -1 modifier to determine rotation direction
    let modifier = rotateRight ? -1 : 1
    
    // create sequence of actions to rotate to the right, then reset position
    
    let rotate = SKAction.rotate(byAngle: deg2rad(rotationDegrees * modifier), duration: rotationDuration)
    let wait = SKAction.wait(forDuration: waitDuration)
    let reset = SKAction.rotate(byAngle: deg2rad(rotationDegrees * -modifier), duration: 0)
    
    let sequence = SKAction.sequence([rotate, wait, reset])
    
    run(SKAction.repeatForever(sequence))
  }
  
  func deg2rad(_ degrees: Int) -> CGFloat {
    return CGFloat(Double(degrees) * .pi / 180)
  }
}

