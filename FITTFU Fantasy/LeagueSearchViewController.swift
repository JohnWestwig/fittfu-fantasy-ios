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
    @IBOutlet weak var leagueDetails: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
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
    
    struct League {
        var id: Int
        var name: String
        var lineupCount: Int = 0
    }
    
    var myLeagues: Array<League> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLeagueSearchTable.delegate = self
        myLeagueSearchTable.dataSource = self
        
        APIHandler().makeHTTPRequest("/api/leagues", method: APIHandler.HTTPMethod.get, data: nil, onCompleted:{
            (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                let leagues = data["leagues"] as! [AnyObject]
                for league in leagues {
                    self.myLeagues.append(League(
                        id: league["id"] as! Int,
                        name: league["name"] as! String,
                        lineupCount: league["lineup_count"] as! Int
                    ))
                }
                DispatchQueue.main.async {
                    self.myLeagueSearchTable.reloadData()
                }
            } else {
                //Handle errors:
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueSearchCell", for: indexPath) as! LeagueSearchTableViewCell
        let cellData = myLeagues[indexPath.row]
        cell.leagueName.text = cellData.name
        cell.leagueDetails.text = cellData.lineupCount.description + (cellData.lineupCount == 1 ? " member" : " members")
        cell.onJoinButtonClicked = { (cell) in
            self.presentJoinAlert(leagueId: cellData.id, leagueName: cellData.name)
        }
        return cell;
    }
    
    // UITableViewDelegate Functions
    
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
            self.joinLineup(leagueId: leagueId, lineupName: (alert?.textFields![0].text)!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func joinLineup (leagueId: Int, lineupName: String) {
        print(leagueId)
        let data: [String: String] = ["name": lineupName]
        print(data)
        
        APIHandler().makeHTTPRequest("/api/leagues/" + leagueId.description + "/join", method: APIHandler.HTTPMethod.post, data: data, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                //Return to league view, refresh
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLeagues"), object: nil)
                    self.dismiss(animated: true)
                }
            } else {
                let errorCode = data["errorCode"] as! Int
                switch (errorCode) {
                case 1:
                    let alert = UIAlertController(title: "Error joining", message: "You have already joined this league", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    break
                default:
                    break
                }
            }
        })
    }
}
