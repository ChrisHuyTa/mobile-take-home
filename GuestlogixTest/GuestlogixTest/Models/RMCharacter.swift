//
//  Character.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct CharacterData: Decodable {
    
    var info: Info
    var result: [RMCharacter]
}

struct RMCharacter: Decodable {
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    
}
