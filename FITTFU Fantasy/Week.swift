//
//  Week.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/8/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class Week: CustomStringConvertible {
    var id: Int = -1
    var number: Int = -1
    var editStart: Date = Date.distantFuture
    var editEnd: Date = Date.distantFuture
    var liveStart: Date = Date.distantFuture
    var liveEnd: Date = Date.distantFuture

    var canEdit: Bool {
        let currentDate = Date()
        return  currentDate > editStart && currentDate < editEnd
    }
    
    var isLive: Bool {
        let currentDate = Date()
        return  currentDate > liveStart && currentDate < liveEnd
    }
    
    var description: String {
        return "Id: \(id)\nNumber: \(number)"
    }
    
    init (id: Int = -1, number: Int = -1, editStart: Date = Date.distantFuture, editEnd: Date = Date.distantFuture, liveStart: Date = Date.distantFuture, liveEnd: Date = Date.distantFuture) {
        self.id = id
        self.number = number
        self.editStart = editStart
        self.editEnd = editEnd
        self.liveStart = liveStart
        self.liveEnd = liveEnd
    }
    
    init(jsonData: [String: Any]) {
        print(jsonData)
        id = jsonData["id"] as! Int
        number = jsonData["number"] as! Int
        editStart = formatDate(dateString: jsonData["edit_start"] as! String)
        editEnd = formatDate(dateString: jsonData["edit_end"] as! String)
        liveStart = formatDate(dateString: jsonData["live_start"] as! String)
        liveEnd = formatDate(dateString: jsonData["live_end"] as! String)
    }
    
    private func formatDate (dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)!
    }
}
