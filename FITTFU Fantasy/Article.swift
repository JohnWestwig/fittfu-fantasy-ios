//
//  Article.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/10/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
class Article: CustomStringConvertible {
    var id: Int = -1
    var title: String = ""
    var author: String = ""
    var datePublished: Date = Date.distantPast
    var content: String = ""

    var description: String {
        return "Id: \(id)\nTitle: \(title)"
    }
    
    var datePublishedShort: String {
        let formatter = DateFormatter()
        formatter.dateStyle  = .short
        formatter.timeStyle = .short
        return formatter.string(from: datePublished)
    }

    init(id: Int = -1, title: String = "", author: String = "", datePublished: Date = Date.distantPast, content: String = "") {
        self.id = id
        self.title = title
        self.author = author
        self.datePublished = datePublished
        self.content = content
    }

    init(json: [String: Any]) {
        self.id = json["id"] as! Int
        self.title = json["title"] as! String
        self.author = json["author"] as! String
        self.datePublished = formatDate(dateString: json["date_published"] as! String)
        self.content = json["content"] as! String
    }
    
    private func formatDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)!
    }
}
