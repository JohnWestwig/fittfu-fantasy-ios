//
//  Team.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/13/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
class Team: CustomStringConvertible {
    var id: Int = -1
    var name: String = ""
    var players: Array<Player> = []
    
    var description: String {
        return name
    }
    
    init(id: Int = -1, name: String = "", players: Array<Player> = []) {
        self.id = id
        self.name = name
        self.players = players
    }
    
    init (json: [String: Any]) {
        id = json["id"] as! Int
        name = json["name"] as! String
        for player in json["players"] as! [[String: Any]] {
            players.append(Player(from: player))
        }
    }
}
