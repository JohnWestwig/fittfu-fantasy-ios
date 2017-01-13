//
//  APIHandler.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/1/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
import UIKit

typealias onSuccess = (AnyObject) -> Void
typealias onError = (APIError) -> Void

class APIRequest {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    //static let baseURL = "http://localhost:8000"
    static let baseURL = "http://192.168.1.251:8000"
    //static let baseURL = "http://ec2-54-149-157-80.us-west-2.compute.amazonaws.com:8000"
    //static let baseURL = "http://johnwestwig.com:8000"
    
    static func send(_ path: String, method: HTTPMethod, data: [String: String]?, onSuccess: @escaping onSuccess, onError: @escaping onError, senderView: UIView, showLoading: Bool = true) {
        let url: URL = URL(string: baseURL + path)!
        let session = URLSession.shared
        
        /* Start loading indicator */
        if (showLoading) {
            LoadingOverlay.shared.add(view: senderView)
        }
        
        /* Setup HTTP request */
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = getAPIToken() {
            request.addValue(token, forHTTPHeaderField: "x-token")
        }
        
        /* Add in any POST data */
        if (data != nil) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data!, options: [])
            } catch let jsonError as NSError {
                print("Could not generate JSON: ", jsonError)
                return
            }
        }
        
        /* Send request & process the response */
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if (error == nil) {
                do {
                    /* Parse data as JSON */
                    var parsedData: AnyObject = [] as AnyObject
                    if (data != nil && data!.count > 0) {
                        parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    }
    
                    /* Determine the HTTP response code, and call the appropriate function */
                    let httpResponse = response as! HTTPURLResponse
                    if (httpResponse.statusCode == 200) {
                        onSuccess(parsedData)
                    } else {
                        let errorData = parsedData as! [String: Any]
                        let apiError = APIError(
                            statusCode: httpResponse.statusCode,
                            errorCode: errorData["errorCode"] as! Int,
                            message: errorData["message"] as! String,
                            details: errorData["description"] as! String
                        )
                        onError(apiError)
                    }
                
                } catch let jsonError as NSError {
                    print("Could not parse JSON", jsonError)
                }
            } else {
                print("URL session error: ", error ?? "Unknown URL session error")
            }
            if (showLoading) {
                LoadingOverlay.shared.remove()
            }
        })
        task.resume()
    }
    
    static fileprivate func getAPIToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
}
