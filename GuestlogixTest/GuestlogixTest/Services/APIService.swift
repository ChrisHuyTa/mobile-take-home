//
//  APIService.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

protocol APIService {
    func fetchEpisodes(page: Int, completionHandler: @escaping (EpisodeResponse?, HttpError?) -> Void)
    
    func fetchCharacters(ids: [String], completionHandler: @escaping ([RMCharacter]?, HttpError?) -> Void)
}

struct APIServiceClient: APIService {
    
    func fetchEpisodes(page: Int = 1, completionHandler: @escaping (EpisodeResponse?, HttpError?) -> Void) {
        
        let url = URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")!
        
        print("requesting from \(url)...")
        HttpClient.request(from: url) { (jsonData, httpError) in
            
            guard httpError == nil else {
                completionHandler(nil, httpError)
                return
            }
            
            do {
                let episodeResponse = try JSONDecoder().decode(EpisodeResponse.self, from: jsonData!)
                completionHandler(episodeResponse, nil)
            } catch let error as NSError {
                completionHandler(nil, HttpError(
                    errorCode: HttpErrorCode.other,
                    errorDetails: error.userInfo as
                        Dictionary<NSObject, AnyObject>?))
            }
        }
    }
    
    func fetchCharacters(ids: [String], completionHandler: @escaping ([RMCharacter]?, HttpError?) -> Void) {
        let param = ids.joined(separator: ",")
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(param)")!
        print("requesting from \(url)...")
        
        HttpClient.request(from: url) { (jsonData, httpError) in
            
            guard httpError == nil else {
                completionHandler(nil, httpError)
                return
            }
            
            do {
                let characterList = try JSONDecoder().decode([RMCharacter].self, from: jsonData!)
                completionHandler(characterList, nil)
            } catch let error as NSError {
                completionHandler(nil, HttpError(
                                        errorCode: HttpErrorCode.other,
                                        errorDetails: error.userInfo as
                                            Dictionary<NSObject, AnyObject>?))
            
            }
        }
    }

}
