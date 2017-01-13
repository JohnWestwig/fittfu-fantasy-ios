//
//  Game.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/13/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
class Game: CustomStringConvertible {
    var id: Int = -1
    var date: Date = Date.distantFuture
    var homeTeam: Team = Team()
    var awayTeam: Team = Team()
    
    var description: String {
        return "\(homeTeam.description) vs. \(awayTeam.description)"
    }
    
    init (id: Int = -1, date: Date = Date.distantFuture, homeTeam: Team = Team(), awayTeam: Team = Team()) {
        self.id = id
        self.date = date
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    init (json: [String: Any]) {
        print(json)
        id = json["id"] as! Int
        homeTeam = Team(json: json["home_team"] as! [String: Any])
        awayTeam = Team(json: json["away_team"] as! [String: Any])
    }
}
