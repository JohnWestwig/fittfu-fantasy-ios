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
    @IBOutlet weak var myLeagueLineupCountLabel: UILabel!
    @IBOutlet weak var myLeagueImageView: UIImageView!
}

class LeagueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Properties
    
    @IBOutlet weak var myLeagueTable: UITableView!
    
    struct leagueItem {
        var id: Int
        var name: String
    }
    var myLeagues: Array<leagueItem> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Lineup view did load")
        
        myLeagueTable.delegate = self
        myLeagueTable.dataSource = self
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"reloadLeagues"), object:nil, queue:nil) {
            notification in
            self.loadData()
        }
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoHomepageView") {
            let destinationHomepageView = segue.destination as! HomepageViewController
            let indexPath = self.myLeagueTable.indexPathForSelectedRow
            destinationHomepageView.myLeagueId = self.myLeagues[indexPath!.row].id
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! LeagueTableViewCell
        let cellData = myLeagues[indexPath.row]
        cell.myLeagueNameLabel.text = cellData.name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoHomepageView", sender: nil)
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    //MARK: Actions
    
    @IBAction func myAddLeagueButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoLeagueSearchView", sender: sender)
    }

    private func loadData() {
        APIHandler().makeHTTPRequest("/api/leagues/me", method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            print(data)
            self.myLeagues = []
            let leagues = data["leagues"] as! [AnyObject]
            for league in leagues {
                self.myLeagues.append(leagueItem(
                    id: league["id"] as! Int,
                    name: league["name"] as! String
                ))
            }
            
            DispatchQueue.main.async(execute: {
                self.myLeagueTable.reloadData()
            })
        })
    }
}

