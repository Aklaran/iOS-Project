//
//  BatTest.swift
//  ddrTests
//
//  Created by Matt Kern on 11/3/19.
//  Copyright © 2019 the3amigos. All rights reserved.
//

import XCTest
@testable import ddr

class BatTest: XCTestCase {
  
  var audioManager : AudioManager? = nil
  var bat1 : Bat? = nil

  override func setUp() {
    audioManager = AudioManager()
    bat1 = Bat(audioManager: audioManager!)
  }

  func testUpdateSize() {
    XCTAssertEqual(CGFloat(0), bat1!.xScale)
    XCTAssertEqual(CGFloat(0), bat1!.yScale)
    bat1!.z = 0
    XCTAssertEqual(CGFloat(1), bat1!.xScale)
    XCTAssertEqual(CGFloat(1), bat1!.yScale)
  }

}
