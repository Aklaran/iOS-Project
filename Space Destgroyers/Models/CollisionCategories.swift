//
//  CollisionCategories.swift
//  Space Destgroyers
//
//  Created by Matt Kern on 10/26/19.
//  Copyright © 2019 Matt Kern. All rights reserved.
//

import Foundation

struct CollisionCategories{
  static let Invader : UInt32 = 0x1 << 0
  static let Player: UInt32 = 0x1 << 1
  static let InvaderBullet: UInt32 = 0x1 << 2
  static let PlayerBullet: UInt32 = 0x1 << 3
  static let EdgeBody: UInt32 = 0x1 << 4
}
