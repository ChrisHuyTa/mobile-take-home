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
    
    func fetchCharacters()
}

class APIServiceClient: APIService {
    
    
    
    func fetchEpisodes(page: Int = 1, completionHandler: @escaping (EpisodeData?) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")!
        print("requesting from \(url)...")
        HttpClient.request(from: url) { (jsonData, httpError) in
            

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
    

}
