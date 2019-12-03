//
//  BatTest.swift
//  ddrTests
//
//  Created by Matt Kern on 11/3/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import XCTest
import SpriteKit
@testable import ddr

class BatTest: XCTestCase {
  
  var _game : GameScene?
  var game = GameScene()

  var audioManager : AudioManager? = nil
  var bat1 : Bat? = nil

  override func setUp() {
    _game = GameScene(size: UIScreen.main.bounds.size)
    _game?.didMove(to: SKView())
    game = _game!
    
    audioManager = AudioManager()
    bat1 = Bat()
  }

  func testUpdateSize() {
    XCTAssertEqual(CGFloat(0), bat1!.xScale)
    XCTAssertEqual(CGFloat(0), bat1!.yScale)
    bat1!.zPosition = 0
    XCTAssertEqual(CGFloat(1), bat1!.xScale)
    XCTAssertEqual(CGFloat(1), bat1!.yScale)
  }

  func testUpdateEmitterZ() {
    let testPoint = CGPoint(x: 0, y: 0)
    XCTAssertNotEqual(testPoint, bat1!.position)
    XCTAssertNotEqual(testPoint.x, bat1!.flapping.x)
    XCTAssertNotEqual(testPoint.y, bat1!.flapping.y)
    bat1!.position = testPoint
    XCTAssertEqual(testPoint, bat1!.position)
    XCTAssertEqual(testPoint.x, bat1!.flapping.x)
    XCTAssertEqual(testPoint.y, bat1!.flapping.y)
  }

  func testMove() {
    bat1!.speed = 99
    let startZ = bat1!.zPosition
    bat1!.move()
    XCTAssertEqual(startZ - 99, bat1!.zPosition)
  }

  func testIsGone() {
    bat1!.zPosition = GameScene.HORIZON - 1
    XCTAssertFalse(bat1!.isGone())
    bat1!.zPosition = GameScene.HORIZON
    XCTAssertFalse(bat1!.isGone())
    bat1!.zPosition = GameScene.HORIZON + 1
    XCTAssert(bat1!.isGone())
  }

  func testDie() {
    XCTAssert(bat1!.flapping.player.isPlaying)
    bat1!.despawn()
    XCTAssertFalse(bat1!.flapping.player.isPlaying)
  }

//  func testHit() {
//    guard let bat = bat1 else {
//      return
//    }
//    bat.isHidden = false
//    bat.applyCollisionEffects(to: game)
//    XCTAssertTrue(bat.isHidden)
//  }

  func testPass() {
    guard let bat = bat1 else {
      return
    }
    bat.isHidden = false
    bat.applyPassEffects(to: game)
    XCTAssertTrue(bat.isHidden)
  }
  
  func testGetTrainingBat() {
    let bat = Bat.getTrainingBat(position: ScreenThird.LEFT)
    XCTAssertEqual(ScreenThird.LEFT, ScreenThird.of(x: bat.position.x))
  }

}
