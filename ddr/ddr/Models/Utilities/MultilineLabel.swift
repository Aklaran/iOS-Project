//
//  MultilineLane.swift
//  ddr
//
//  Created by Siri  Tembunkiart on 12/12/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import Foundation
import SpriteKit

class MultilineLabel {
  var labels = [SKLabelNode]()
  
  var fontName : String = "PressStart2P-Regular" {
    didSet {
      labels.forEach{ $0.fontName = fontName }
    }
  }
  
  var fontSize : CGFloat = 16 {
    didSet {
      labels.forEach{ $0.fontSize = fontSize }
      setLabelPositions(self.position)
    }
  }
  
  var horizontalAlignment : SKLabelHorizontalAlignmentMode = .center {
    didSet {
      labels.forEach{ $0.horizontalAlignmentMode = horizontalAlignment }
    }
  }
  
  var position : CGPoint = CGPoint(x:0, y:0) {
    didSet {
      setLabelPositions(position)
    }
  }

  init(text: String) {
    for line in text.split(whereSeparator: { $0.isNewline }) {
      let lineText = String(line)
      labels.append(SKLabelNode(text: lineText))
    }
  }
  
  func setLabelPositions(_ position: CGPoint) {
    let halfIndex = labels.count / 2
    
    for (i, label) in labels.enumerated() {
      let distFromCenter = CGFloat(i - halfIndex)
      
      var labelPosition = position
      labelPosition.y -= (fontSize * 1.25) * distFromCenter
      
      label.position = labelPosition
    }
  }
  
  func parentToScene(scene: SKScene) {
    labels.forEach{ scene.addChild($0) }
  }
}
