//
//  GamesViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/13/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class HomeTeamPlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myOwnedLabel: UILabel!
    @IBOutlet weak var myPlayerNameLabel: UILabel!
    @IBOutlet weak var myPlayerDetailsLabel: UILabel!
    @IBOutlet weak var myPlayerScoreLabel: UILabel!
}

class AwayTeamPlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var myOwnedLabel: UILabel!
    @IBOutlet weak var myPlayerNameLabel: UILabel!
    @IBOutlet weak var myPlayerDetailsLabel: UILabel!
    @IBOutlet weak var myPlayerScoreLabel: UILabel!
}

class GameTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myHomeTeamNameLabel: UILabel!
    @IBOutlet weak var myAwayTeamNameLabel: UILabel!
    @IBOutlet weak var myHomeTeamPlayerTable: UITableView!
    @IBOutlet weak var myAwayTeamPlayerTable: UITableView!
    
    var myHomeTeam: Team = Team()
    var myAwayTeam: Team = Team()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myHomeTeamPlayerTable.delegate = self
        myHomeTeamPlayerTable.dataSource = self
        myAwayTeamPlayerTable.delegate = self
        myAwayTeamPlayerTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == myHomeTeamPlayerTable ? myHomeTeam.players.count : myAwayTeam.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == myHomeTeamPlayerTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTeamPlayerCell", for: indexPath) as! HomeTeamPlayerTableViewCell
            let player = myHomeTeam.players[indexPath.row]
            cell.myPlayerNameLabel.text = player.name
            cell.myPlayerDetailsLabel.text = "\(player.nickname) • \(player.year)"
            cell.myOwnedLabel.text = player.owned ? "\u{2713}" : ""
            cell.myPlayerScoreLabel.text = player.score.description
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "awayTeamPlayerCell", for: indexPath) as! AwayTeamPlayerTableViewCell
            let player = myAwayTeam.players[indexPath.row]
            cell.myPlayerNameLabel.text = player.name
            cell.myPlayerDetailsLabel.text = "\(player.nickname) • \(player.year)"
            cell.myOwnedLabel.text = player.owned ? "\u{2713}" : ""
            cell.myPlayerScoreLabel.text = player.score.description
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Properties
    @IBOutlet weak var myWeekPicker: UIPickerView!
    @IBOutlet weak var myGamesTable: UITableView!
    
    var myLeague: League = League()
    var myCurrentWeek: Week = Week()
    var myWeeks: Array<Week> = []
    var myLineup: Lineup = Lineup()
    var myGames: Array<Game> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myGamesTable.delegate = self
        myGamesTable.dataSource = self
        
        myWeekPicker.delegate = self
        myWeekPicker.dataSource = self
        
        loadGames(weekId: myCurrentWeek.id)
        loadWeeks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let game = myGames[indexPath.row]
        cell.myHomeTeamNameLabel.text = game.homeTeam.name
        cell.myAwayTeamNameLabel.text = game.awayTeam.name
        cell.myHomeTeam = game.homeTeam
        cell.myAwayTeam = game.awayTeam
        cell.myHomeTeamPlayerTable.reloadData()
        cell.myAwayTeamPlayerTable.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    /* Picker */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myWeeks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Week \(myWeeks[row].number)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadGames(weekId: myWeeks[row].id)
    }
    
    private func loadGames(weekId: Int) {
        APIMethods.getGames(weekId: weekId, lineupId: myLineup.id, onSuccess: { (games) in
            self.myGames = games
            DispatchQueue.main.async {
                self.myGamesTable.reloadData()
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }
    
    private func loadWeeks() {
        APIMethods.getWeeks(leagueId: myLeague.id, onSuccess: { (weeks) in
            self.myWeeks = weeks
            DispatchQueue.main.async {
                self.myWeekPicker.reloadAllComponents()
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }
}
