//
//  APIMethods.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/7/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
import UIKit

class APIMethods {
    /* Authentication */
    static func login(email: String, password: String, onSuccess: @escaping (_ token: String) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/login", method: .post, data: ["email": email, "password": password], onSuccess: { (data) in
            onSuccess(data["token"] as! String)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func register(email: String, password: String, firstName: String, lastName: String, onSuccess: @escaping () -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/register", method: .post, data: ["email": email, "password": password, "firstName": firstName, "lastName": lastName], onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func validateToken(onSuccess: @escaping () -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/validateToken", method: .get, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    /* Leagues */
    static func getLeagues(me: Bool? = false, onSuccess: @escaping ([League]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues" + (me! ? "?me" : ""), method: .get, data: nil, onSuccess: { (data) in
            var leagues: Array<League> = []
            for league in data["leagues"] as! [[String: Any]] {
                leagues.append(League(from: league))
            }
            onSuccess(leagues)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func joinLeague(leagueId: Int, lineupName: String, onSuccess: @escaping () -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues/\(leagueId)/lineups", method: .post, data: ["lineupName": lineupName], onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getWeeks(leagueId: Int, onSuccess: @escaping ([Week]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues/\(leagueId)/weeks", method: .get, data: nil, onSuccess: { (data) in
            var weeks: Array<Week> = []
            for week in data["weeks"] as! [[String: Any]] {
                weeks.append(Week(jsonData: week))
            }
            onSuccess(weeks)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getCurrentWeek(leagueId: Int, onSuccess: @escaping (Week) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues/\(leagueId)/weeks/current", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Week(jsonData: data["week"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getArticles(leagueId: Int, onSuccess: @escaping ([Article]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues/\(leagueId)/articles", method: .get, data: nil, onSuccess: { (data) in
            var articles: Array<Article> = []
            for article in data["articles"] as! [[String: Any]] {
                articles.append(Article(json: article))
            }
            onSuccess(articles)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getStandings(leagueId: Int, weekId: Int?, onSuccess: @escaping ([Standing]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/leagues/\(leagueId)/standings" + ((weekId != nil) ? "?week_id=\(weekId!)" : ""), method: .get, data: nil, onSuccess: { (data) in
            var standings: Array<Standing> = []
            for standing in data["standings"] as! [[String: Any]] {
                standings.append(Standing(json: standing))
            }
            onSuccess(standings)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    /* Weeks */
    static func getMyLineup(weekId: Int, onSuccess: @escaping (Lineup) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/weeks/\(weekId)/lineups/me", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Lineup(from: data["lineup"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    /* Lineups */
    static func getLineup(lineupId: Int, onSuccess: @escaping (Lineup) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/lineups/\(lineupId)", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Lineup(from: data["lineup"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getPlayers(lineupId: Int, onSuccess: @escaping ([Player]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/lineups/\(lineupId)/players", method: .get, data: nil, onSuccess: { (data) in
            var players: Array<Player> = []
            for player in data["players"] as! [[String: Any]] {
                players.append(Player(from: player))
            }
            onSuccess(players)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func addPlayer(lineupId: Int, playerId: Int, onSuccess: @escaping () -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/lineups/\(lineupId)/players/\(playerId)", method: .put, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func removePlayer(lineupId: Int, playerId: Int, onSuccess: @escaping () -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/lineups/\(lineupId)/players/\(playerId)", method: .delete, data: nil, onSuccess: { (data) in
            onSuccess()
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }

    /* Players */
    static func getPlayer(playerId: Int, lineupId: Int?, onSuccess: @escaping (Player) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/players/\(playerId)" + ((lineupId != nil) ? "?lineup_id=\(lineupId!)" : ""), method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Player(from: data["player"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    static func getPlayerStats(playerId: Int, leagueId: Int, onSuccess: @escaping ([WeeklyStats]) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/players/\(playerId)/weeklyStats?league_id=\(leagueId)", method: .get, data: nil, onSuccess: { (data) in
            var stats: Array<WeeklyStats> = []
            for stat in data["stats"] as! [[String: Any]] {
                stats.append(WeeklyStats(from: stat))
            }
            onSuccess(stats)
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
    
    /* Articles */
    static func getArticle(articleId: Int, onSuccess: @escaping (Article) -> Void, onError: @escaping onError, senderView: UIView) {
        APIRequest.send("/api/articles/\(articleId)", method: .get, data: nil, onSuccess: { (data) in
            onSuccess(Article(json: data["article"] as! [String: Any]))
        }, onError: { (error) in
            onError(error)
        }, senderView: senderView)
    }
}



    
