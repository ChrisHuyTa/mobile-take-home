//
//  Episode.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct EpisodeResponse: Decodable {
    var info: Info
    var results: [Episode]
}

struct Episode: Decodable {
    
    var id: Int
    var name: String
    var air_date: String
    var episode: String
    var characters: [String]
    var url: String
    var created: String
    
}
