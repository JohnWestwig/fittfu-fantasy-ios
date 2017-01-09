//
//  APIMethods.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/7/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation

class APIMethods {
    /* Authentication */
    static func login(email: String, password: String, onSuccess: @escaping (_ token: String) -> Void, onError: @escaping onError) {
        APIRequest.send("/login", method: .post, data: ["email": email, "password": password], onSuccess: { (data) in
            onSuccess(data["token"] as! String)
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func register(email: String, password: String, firstName: String, lastName: String, onSuccess: @escaping () -> Void, onError: @escaping onError) {
        APIRequest.send("/register", method: .post, data: ["email": email, "password": password, "firstName": firstName, "lastName": lastName], onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func validateToken(onSuccess: @escaping () -> Void, onError: @escaping onError) {
        APIRequest.send("/api/validateToken", method: .get, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        })
    }
    
    /* Leagues */
    static func getLeagues(me: Bool? = false, onSuccess: @escaping ([League]) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/leagues" + (me! ? "?me" : ""), method: .get, data: nil, onSuccess: { (data) in
            var leagues: Array<League> = []
            for league in data["leagues"] as! [[String: Any]] {
                leagues.append(League(from: league))
            }
            onSuccess(leagues)
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func joinLeague(leagueId: Int, lineupName: String, onSuccess: @escaping () -> Void, onError: @escaping onError) {
        APIRequest.send("/api/leagues/\(leagueId)/lineups", method: .post, data: ["lineupName": lineupName], onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func getCurrentWeek(leagueId: Int, onSuccess: @escaping (Week) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/leagues/\(leagueId)/weeks/current", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Week(jsonData: data["week"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        })
    }
    
    /* Weeks */
    static func getMyLineup(weekId: Int, onSuccess: @escaping (Lineup) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/weeks/\(weekId)/lineups/me", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Lineup(from: data["lineup"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        })
    }
    
    /* Lineups */
    static func getLineup(lineupId: Int, onSuccess: @escaping (Lineup) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/lineups/\(lineupId)", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Lineup(from: data["lineup"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func getPlayers(lineupId: Int, onSuccess: @escaping ([Player]) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/lineups/\(lineupId)/players", method: .get, data: nil, onSuccess: { (data) in
            var players: Array<Player> = []
            for player in data["players"] as! [[String: Any]] {
                players.append(Player(from: player))
            }
            onSuccess(players)
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func addPlayer(lineupId: Int, playerId: Int, onSuccess: @escaping () -> Void, onError: @escaping onError) {
        APIRequest.send("/api/lineups/\(lineupId)/players/\(playerId)", method: .put, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func removePlayer(lineupId: Int, playerId: Int, onSuccess: @escaping () -> Void, onError: @escaping onError) {
        APIRequest.send("/api/lineups/\(lineupId)/players/\(playerId)", method: .delete, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        })
    }

    /* Players */
    static func getPlayer(playerId: Int, lineupId: Int?, onSuccess: @escaping (Player) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/players/\(playerId)" + ((lineupId != nil) ? "?lineup_id=\(lineupId!)" : ""), method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Player(from: data["player"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        })
    }
    
    static func getPlayerStats(playerId: Int, leagueId: Int, onSuccess: @escaping ([WeeklyStats]) -> Void, onError: @escaping onError) {
        APIRequest.send("/api/players/\(playerId)/weeklyStats?league_id=\(leagueId)", method: .get, data: nil, onSuccess: { (data) in
            var stats: Array<WeeklyStats> = []
            for stat in data["stats"] as! [[String: Any]] {
                stats.append(WeeklyStats(from: stat))
            }
            onSuccess(stats)
        }, onError: { (error) in
            onError(error)
        })
    }
}



    
