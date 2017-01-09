//
//  APIError.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/7/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

struct APIError: CustomStringConvertible {
    let statusCode: Int
    let errorCode: Int
    let message: String
    let details: String
    
    var description: String {
        return "Status Code: \(statusCode)\nError Code: \(errorCode)\nMessage: \(message)\nDetails: \(details)"
    }
}
