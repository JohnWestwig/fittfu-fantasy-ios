//
//  LeagueSearchViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/3/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import Foundation
import UIKit

class LeagueSearchTableViewCell: UITableViewCell {
    var onJoinButtonClicked: ((UITableViewCell) -> Void)?
    
    //MARK: Properties
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueDetails: UILabel!
    @IBOutlet weak var leagueJoinButton: UIButton!
    
    //MARK: Actions
    @IBAction func leagueJoinButtonClicked(_ sender: UIButton) {
        onJoinButtonClicked?(self)
    }
}

class LeagueSearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var myLeagueSearchBar: UISearchBar!
    @IBOutlet weak var myLeagueSearchTable: UITableView!
    
    var myLeagues: Array<League> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLeagueSearchTable.delegate = self
        myLeagueSearchTable.dataSource = self
        
        APIMethods.getLeagues(me: false, onSuccess: { (leagues) in
            self.myLeagues = leagues
            DispatchQueue.main.async {
                self.myLeagueSearchTable.reloadData()
            }
        }, onError: { (error) in
            print(error)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueSearchCell", for: indexPath) as! LeagueSearchTableViewCell
        let league = myLeagues[indexPath.row]
        cell.leagueName.text = league.name
        cell.leagueDetails.text = "\(league.weekCount) weeks • \(league.lineupCount) lineups"
        cell.onJoinButtonClicked = { (cell) in
            self.presentJoinAlert(leagueId: league.id, leagueName: league.name)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: Actions
    
    @IBAction func myCancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //Private methods
    
    private func presentJoinAlert(leagueId: Int, leagueName: String) {
        let alert = UIAlertController(title: "Joining " + leagueName, message: "Please name your lineup", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (leagueName) in
            leagueName.placeholder = "My Lineup"
        })
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: {
            [weak alert] (action) -> Void in
            APIMethods.joinLeague(leagueId: leagueId, lineupName: (alert?.textFields![0].text)!, onSuccess: {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLeagues"), object: nil)
                    self.dismiss(animated: true)
                }
            }, onError: { (error) in
                switch (error.errorCode) {
                case 1000:
                    let alert = UIAlertController(title: "Error joining", message: "You have already joined this league", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    break
                default:
                    break
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
