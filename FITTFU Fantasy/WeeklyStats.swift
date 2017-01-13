//
//  WeeklyStats.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/8/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class StatsCategory: CustomStringConvertible {
    var name: String
    var value: Int
    var count: Int
    
    var total: Int {
        return value * count
    }
    
    var description: String {
        return name
    }
    
    init(from json: [String: Any]) {
        name = json["name"] as! String
        value = json["value"] as! Int
        count = json["count"] as! Int
    }
}

class WeeklyStats: CustomStringConvertible {
    var weekId: Int
    var weekNumber: Int
    var categories: Array<StatsCategory>
    
    var description: String {
        return "Week \(weekNumber):\n\(categories)"
    }
    
    var total: Int {
        return categories.reduce(0, { (result, category) -> Int in
            return result + category.total
        })
    }
    
    init(weekId: Int = -1, weekNumber: Int = -1, categories: Array<StatsCategory> = []) {
        self.weekId = weekId
        self.weekNumber = weekNumber
        self.categories = categories
    }
    
    init (from json: [String: Any]) {
        weekId = json["week_id"] as! Int
        weekNumber = json["week_number"] as! Int
        categories = []
        for category in json["categories"] as! [[String: Any]] {
            categories.append(StatsCategory(from: category))
        }
    }
    
}
