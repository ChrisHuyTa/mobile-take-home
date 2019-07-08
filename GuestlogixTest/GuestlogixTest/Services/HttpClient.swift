//
//  HttpClient.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct HttpClient {
    
    static func request(from url: URL,
                        completionHandler: @escaping (AnyObject?, HttpError?) -> Void) {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completionHandler(nil, HttpError(errorCode: HttpErrorCode.noResponse,
                                                 errorDetails: error?._userInfo as! Dictionary<NSObject, AnyObject>?))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completionHandler(nil, HttpError(errorCode: HttpErrorCode(rawValue: httpResponse.statusCode)!,
                                                 errorDetails: error?._userInfo as! Dictionary<NSObject, AnyObject>?))
                return
            }
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let unserializedJson = try JSONSerialization.jsonObject(
                    with: jsonData,
                    options: JSONSerialization.ReadingOptions.mutableContainers)
                if let parsedJsonDictionary =
                    unserializedJson as? [String: AnyObject] {
                    completionHandler(parsedJsonDictionary as AnyObject?, nil)
                } else if let parsedJsonArray
                    = unserializedJson as? Array<AnyObject> {
                    completionHandler(parsedJsonArray as AnyObject?, nil)
                }
            } catch let error as NSError {
                completionHandler(nil, HttpError(
                    errorCode: HttpErrorCode.other,
                    errorDetails: error.userInfo as
                        Dictionary<NSObject, AnyObject>?))
            }
            
        }
        
        dataTask.resume()
    }
    
}

struct HttpError {
    let errorCode: HttpErrorCode
    let errorDetails: Dictionary<NSObject, AnyObject>?
}


enum HttpErrorCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case internalServerError = 500
    case badGateway = 502
    case other = 0
    case noResponse = -1
}
