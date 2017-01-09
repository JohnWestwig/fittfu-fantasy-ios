//
//  Lineup.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/8/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
class Lineup: CustomStringConvertible {
    var id: Int
    var name: String
    var moneyTotal: Int
    var moneySpent: Int = 0
    
    var moneyLeft: Int {
        return moneyTotal - moneySpent
    }
    
    var fractionMoneySpent: Float {
        return Float(moneySpent) / Float(moneyTotal)
    }
    
    var description: String {
        return "Id: \(id)\nName: \(name)\nMoney Total: \(moneyTotal)\nMoney Spent: \(moneySpent)"
    }
    
    init (id: Int = -1, name: String = "", moneyTotal: Int = 0, moneySpent: Int = 0) {
        self.id = id
        self.name = name
        self.moneyTotal = moneyTotal
        self.moneySpent = moneySpent
    }
    
    init (from json: [String: Any]) {
        id = json["id"] as! Int
        name = json["name"] as! String
        moneyTotal = json["money_total"] as! Int
        moneySpent = json["money_spent"] as? Int ?? 0
    }
}
