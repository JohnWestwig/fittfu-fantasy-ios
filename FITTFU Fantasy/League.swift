//
//  League.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/7/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class League : CustomStringConvertible {
    let id: Int
    let name: String
    let image: URL?
    let weekCount: Int
    let lineupCount: Int
    
    var description: String {
        return "Id: \(id)\nName: \(name)"
    }
    
    init(id: Int = -1, name: String = "", image: URL? = nil, weekCount: Int = 0, lineupCount: Int = 0) {
        self.id = id
        self.name = name
        self.image = image
        self.lineupCount = lineupCount
        self.weekCount = weekCount
    }
    
    init(from json: [String: Any]) {
        self.id = json["id"] as? Int ?? 0
        self.name = json["name"] as? String ?? ""
        self.lineupCount = json["lineup_count"] as? Int ?? 0
        self.weekCount = json["week_count"] as? Int ?? 0
        if let imageStr = json["image"] as? String {
            self.image = URL(string: imageStr)
        } else {
            self.image = nil
        }
    }
}
