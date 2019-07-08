//
//  APIService.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

protocol APIService {
    func fetchEpisodes(page: Int, completionHandler: @escaping (EpisodeData?) -> Void)
    
    func fetchCharacters(ids: [String], completionHandler: @escaping ([RMCharacter]?) -> Void)
}

class APIServiceClient: APIService {
    
    
    func fetchEpisodes(page: Int = 1, completionHandler: @escaping (EpisodeData?) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")!
        print("requesting from \(url)...")
        HttpClient.request(from: url) { (jsonData, httpError) in
            
            debugPrint("retrieved episodes: \(jsonData!)")
            
            guard httpError == nil else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonData as Any, options: [])
                if let string = String(data: data, encoding: String.Encoding.utf8)?.data(using: .utf8) {
                    let episodeData = try JSONDecoder().decode(EpisodeData.self, from: string)
                    completionHandler(episodeData)
                }
            } catch {
                completionHandler(nil)
            }
        }
    }
    
    func fetchCharacters(ids: [String], completionHandler: @escaping ([RMCharacter]?) -> Void) {
        let param = ids.joined(separator: ",")
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(param)")!
        print("requesting from \(url)...")
        HttpClient.request(from: url) { (jsonData, httpError) in
            
            guard httpError == nil else {
                return
            }
            
            debugPrint("retrieved characters: \(jsonData!)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonData as Any, options: [])
                if let string = String(data: data, encoding: String.Encoding.utf8)?.data(using: .utf8) {
                    let characterList = try JSONDecoder().decode([RMCharacter].self, from: string)
                    completionHandler(characterList)
                }
            } catch {
                completionHandler(nil)
            }
        }
    }

}
