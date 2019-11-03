//
//  AudioManagerTest.swift
//  ddrTests
//
//  Created by Matt Kern on 11/3/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import XCTest
@testable import ddr


class AudioManagerTest: XCTestCase {
  
  var am : AudioManager? = nil

  override func setUp() {
      am = AudioManager()
  }
  
  // tried doing this but dependency on singleFlap.mp3 fails

  func testCreateEmitter() {
    XCTAssertEqual(0, am!.emitters.count)
    let zMax = CGFloat(99)
    let soundFile = "singleFlap.mp3"
    let e = am!.createEmitter(soundFile: soundFile, maxZMagnitude: zMax)
    XCTAssertEqual(1, am!.emitters.count)
    XCTAssertEqual(zMax, e.maxZMagnitude)
  }
//
//  func testUpdateListenerPosition() {
//    let newPos = CGPoint(x: 13, y: 12)
//    let soundFile = "singleFlap.mp3"
//    let e1 = am!.createEmitter(soundFile: soundFile, maxZMagnitude: 99)
//    let e2 = am!.createEmitter(soundFile: soundFile, maxZMagnitude: 98)
//    XCTAssertNotEqual(newPos, e1.destination)
//    XCTAssertNotEqual(newPos, e2.destination)
//    am?.updateListenerPosition(to: newPos)
//    XCTAssertEqual(newPos, e1.destination)
//    XCTAssertEqual(newPos, e2.destination)
//  }

}
