//
//  Player.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/8/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class Player: CustomStringConvertible {
    var id: Int
    var firstName: String
    var lastName: String
    var price: Int
    var year: String
    var nickname: String
    var image: URL?
    var owned: Bool
    var score: Int
    var teamName: String = ""
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    var description: String {
        //TODO complete
        return name
    }
    
    init(id: Int = -1, firstName: String = "", lastName: String = "", price: Int = 0, year: String = "", nickname: String = "", image: URL? = nil, owned: Bool = false, score: Int = 0, teamName: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.price = price
        self.year = year
        self.nickname = nickname
        self.image = image
        self.owned = owned
        self.score = score
        self.teamName = teamName
    }
    
    init (from json: [String: Any]) {
        id = json["id"] as! Int
        firstName = json["first_name"] as! String
        lastName = json["last_name"] as! String
        price = json["price"] as? Int ?? 0
        year = json["year"] as! String
        nickname = json["nickname"] as! String
        if let imageStr = json["image"] as? String {
            image = URL(string: imageStr)
        } else {
            image = nil
        }
        owned = json["owned"] as? Bool ?? false
        score = json["points"] as? Int ?? 0
        teamName = json["team_name"] as? String ?? ""
    }
}
