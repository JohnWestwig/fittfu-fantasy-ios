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
        case GET
        case POST
    }
    
    let baseURL = "http://localhost:8000"
    
    func makeHTTPRequest(path: String, method: HTTPMethod, data: [String:String], onCompleted: (AnyObject, NSURLResponse?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: baseURL + path)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        switch (method) {
            case HTTPMethod.GET:
                request.HTTPMethod = "GET"
            case HTTPMethod.POST:
                request.HTTPMethod = "POST"
        }
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            print(request.HTTPBody)
        } catch let jsonError as NSError {
            print("JSON creation error", jsonError)
        }
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if (error == nil) {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String : AnyObject]
                    onCompleted(parsedData, response, error)
                
                } catch let jsonError as NSError {
                    print("JSON parsing error", jsonError)
                }
            } else {
                print("ERROR OCCURED", error)
            }
            
        }
        
        task.resume()
    }
}