//
//  RiderTest.swift
//  ddrTests
//
//  Created by Matt Kern on 11/5/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import XCTest
import CoreMotion
import ddr
import SceneKit
@testable import ddr

class SneakyAudioManager : AudioManager {
  override func updateListenerPosition(to newPosition: CGPoint) {
    super.updateListenerPosition(to: newPosition)
    RiderTest.listenerPositionUpdated = true
  }
}

class RiderTest: XCTestCase {
  
  var motionManager : CMMotionManager? = nil
  var audioManager : AudioManager? = nil
  var rider : Rider? = nil
  
  static var listenerPositionUpdated = false

  override func setUp() {
    RiderTest.listenerPositionUpdated = false
    motionManager = CMMotionManager()
    audioManager = SneakyAudioManager()
    rider = Rider(audioManager: audioManager!, motionManager: motionManager!)
  }

  func testUpdatePosition() {
    rider?.position.x = 0
    XCTAssert(RiderTest.listenerPositionUpdated)
  }
  
  func testRotate() {
    XCTAssertEqual(0, rider?.zRotation)
    rider?.rotate(rotationMultiplier: 2)
    XCTAssertNotEqual(0, rider?.zRotation)
  }
  
  func testLoseLife() {
    rider!.lives = 3
    rider?.loseLife()
    XCTAssertEqual(2, rider!.lives)
  }
  
  func testIsDead() {
    guard let rider = rider else {
      print("this can't happen")
      return
    }
    rider.lives = 1
    XCTAssertFalse(rider.isDead())
    rider.lives = 0
    XCTAssertTrue(rider.isDead())
  }

}
