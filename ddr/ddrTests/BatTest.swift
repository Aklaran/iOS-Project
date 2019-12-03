////
////  BatTest.swift
////  ddrTests
////
////  Created by Matt Kern on 11/3/19.
////  Copyright © 2019 the3amigos. All rights reserved.
////
//
//import XCTest
//@testable import ddr
//
//class BatTest: XCTestCase {
//
//  var audioManager : AudioManager? = nil
//  var bat1 : Bat? = nil
//
//  override func setUp() {
//    audioManager = AudioManager()
//    bat1 = Bat(audioManager: audioManager!, pos: 0, hide: false)
//  }
//
//  func testUpdateSize() {
//    XCTAssertEqual(CGFloat(0), bat1!.xScale)
//    XCTAssertEqual(CGFloat(0), bat1!.yScale)
//    bat1!.z = 0
//    XCTAssertEqual(CGFloat(1), bat1!.xScale)
//    XCTAssertEqual(CGFloat(1), bat1!.yScale)
//  }
//
//  func testUpdateEmitterZ() {
//    let testPoint = CGPoint(x: 0, y: 0)
//    XCTAssertNotEqual(testPoint, bat1!.position)
//    XCTAssertNotEqual(testPoint.x, bat1!.flapping!.x)
//    XCTAssertNotEqual(testPoint.y, bat1!.flapping!.y)
//    bat1!.position = testPoint
//    XCTAssertEqual(testPoint, bat1!.position)
//    XCTAssertEqual(testPoint.x, bat1!.flapping!.x)
//    XCTAssertEqual(testPoint.y, bat1!.flapping!.y)
//  }
//
//  func testMove() {
//    bat1!.velocity = 99
//    let startZ = bat1!.z
//    bat1!.move()
//    XCTAssertEqual(startZ + 99, bat1!.z)
//  }
//
//  func testIsGone() {
//    bat1!.z = Bat.maxZMagnitude - 1
//    XCTAssertFalse(bat1!.isGone())
//    bat1!.z = Bat.maxZMagnitude
//    XCTAssert(bat1!.isGone())
//    bat1!.z = Bat.maxZMagnitude + 1
//    XCTAssert(bat1!.isGone())
//  }
//
//  func testDie() {
//    XCTAssert(bat1!.flapping!.player.isPlaying)
//    bat1!.die()
//    XCTAssertFalse(bat1!.flapping!.player.isPlaying)
//  }
//
//  func testHit() {
//    guard let bat = bat1 else {
//      return
//    }
//    bat.isHidden = false
//    bat.hit()
//    XCTAssertTrue(bat.isHidden)
//  }
//
//  func testPass() {
//    guard let bat = bat1 else {
//      return
//    }
//    bat.isHidden = false
//    bat.pass()
//    XCTAssertTrue(bat.isHidden)
//  }
//
//}
