//
//  APIHandler.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/1/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class APIHandler: NSObject {
    
    enum HTTPMethod {
        case get
        case post
        case delete
    }
    
    //let baseURL = "http://localhost:8000"
    let baseURL = "http://192.168.1.251:8000"
    
    func makeHTTPRequest(_ path: String, method: HTTPMethod, data: [String:String]?, onCompleted: @escaping (AnyObject, URLResponse?, NSError?) -> Void) {
        let url: URL = URL(string: baseURL + path)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        switch (method) {
            case HTTPMethod.get:
                request.httpMethod = "GET"
            case HTTPMethod.post:
                request.httpMethod = "POST"
            case HTTPMethod.delete:
                request.httpMethod = "DELETE"
        }
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token = getAPIToken() {
            request.addValue(token, forHTTPHeaderField: "x-token")
        }
        
        if (data != nil) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data!, options: [])
            } catch let jsonError as NSError {
                print("JSON creation error", jsonError)
            }
        }
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if (error == nil) {
                do {
                    var parsedData:AnyObject = [] as AnyObject
                    if (data != nil && data!.count > 0) {
                        parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    }
                    onCompleted(parsedData, response, nil)
                
                } catch let jsonError as NSError {
                    print("JSON parsing error", jsonError)
                }
            } else {
                print("ERROR OCCURED", error ?? "unreadable error")
            }
        })
        
        task.resume()
    }
    
    fileprivate func getAPIToken() -> String? {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")
        return token
    }
}
