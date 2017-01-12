//
//  Standing.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/10/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
class Standing: CustomStringConvertible {
    var placeNumber: Int = -1
    var ownerName: String = ""
    var lineupName: String = ""
    var points: Int = -1
    
    var description: String {
        return "Hello"
    }
    
    init (json: [String: Any]) {
        placeNumber = json["rank"] as! Int
        ownerName = json["owner_name"] as! String
        lineupName = json["lineup_name"] as! String
        points = json["total_points"] as! Int
    }
}
