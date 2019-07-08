//
//  Info.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct Info: Decodable {
    var count: Int
    var pages: Int
    var next: String
    var prev: String
}
