//
//  LeagueViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/2/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class LeagueTableViewCell : UITableViewCell {
    @IBOutlet weak var myLeagueNameLabel: UILabel!
    @IBOutlet weak var myLeagueImageView: UIImageView!
    @IBOutlet weak var myLeagueDetailsLabel: UILabel!
}

class LeagueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Properties
    
    @IBOutlet weak var myLeagueTable: UITableView!
    
    var myLeagues: Array<League> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLeagueTable.delegate = self
        myLeagueTable.dataSource = self
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: "reloadLeagues"), object: nil, queue: nil) {
            notification in
            self.loadLeagues()
        }
        
        loadLeagues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoHomepageView") {
            let destinationHomepageView = segue.destination as! HomepageViewController
            let indexPath = self.myLeagueTable.indexPathForSelectedRow
            destinationHomepageView.myLeague = self.myLeagues[indexPath!.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! LeagueTableViewCell
        let league = myLeagues[indexPath.row]
        cell.myLeagueNameLabel.text = league.name
        cell.myLeagueDetailsLabel.text = "\(league.weekCount) weeks • \(league.lineupCount) lineups"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoHomepageView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: Actions
    
    @IBAction func myAddLeagueButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoLeagueSearchView", sender: sender)
    }

    private func loadLeagues() {
        APIMethods.getLeagues(me: true, onSuccess: { (leagues) in
            self.myLeagues = leagues
            DispatchQueue.main.async {
                self.myLeagueTable.reloadData()
            }
        }, onError: { (error) in
            print(error)
        })
    }
}

