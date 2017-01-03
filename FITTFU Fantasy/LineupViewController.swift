//
//  LineupViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/1/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var playerPrice: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerDetails: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerOwnedMarker: UILabel!
}

class LineupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    struct playerItem {
        var id: Int
        var price: Int
        var first_name: String
        var last_name: String
        var year: String
        var nickname: String
        var image: URL?
        var owned: Bool = false
    }
    
    var myLineupId: Int = -1
    var myLineupName: String = "My Lineup"
    var myLineupMoneyTotal: Int = 0
    var myLineupMoneySpent: Int = 0
    var myPlayers: [playerItem] = []
    
    //MARK: Properties
    
    @IBOutlet weak var lineupNameLabel: UILabel!
    @IBOutlet weak var lineupMoneyRemainingLabel: UILabel!
    @IBOutlet weak var lineupMoneyRemainingProgress: UIProgressView!
    @IBOutlet weak var playerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerTable.delegate = self
        playerTable.dataSource = self
        
        //self.view.backgroundColor = UIColor(red:0.76, green:0.52, blue:0.25, alpha:1.0)
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        APIHandler().makeHTTPRequest("/api/lineups/" + myLineupId.description, method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let lineup = data["lineup"] as! [String:AnyObject]
            self.myLineupName = lineup["name"] as! String
            self.myLineupMoneyTotal = lineup["money_total"] as! Int
            self.myLineupMoneySpent = lineup["money_spent"] as! Int
            
            DispatchQueue.main.async(execute: {
                self.lineupNameLabel.text = self.myLineupName
                self.lineupMoneyRemainingLabel.text = "$" + (self.myLineupMoneyTotal - self.myLineupMoneySpent).description + " of $" + self.myLineupMoneyTotal.description + " left"
                self.lineupMoneyRemainingProgress.progress = Float(self.myLineupMoneySpent) / Float(self.myLineupMoneyTotal)
            })
        })
        
        APIHandler().makeHTTPRequest("/api/lineups/" + myLineupId.description + "/players", method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let players = data["players"] as! [AnyObject]
            self.myPlayers = []
            for player in players {
                let playerId = player["id"] as! Int
                let playerFirstName = player["first_name"] as! String
                let playerLastName = player["last_name"] as! String
                let playerPrice = player["price"] as! Int
                let playerYear = player["year"] as! String
                let playerNickname = player["nickname"] as! String
                let playerOwned = player["owned"] as! Bool
                if let playerImage = player["image"] as? String {
                    let playerImageUrl = URL(string: playerImage)
                    self.myPlayers.append(playerItem(id: playerId, price: playerPrice, first_name: playerFirstName, last_name: playerLastName, year: playerYear, nickname: playerNickname, image: playerImageUrl, owned: playerOwned))
                } else {
                    self.myPlayers.append(playerItem(id: playerId, price: playerPrice, first_name: playerFirstName, last_name: playerLastName, year: playerYear, nickname: playerNickname, image: nil, owned: playerOwned))
                }

            }
            DispatchQueue.main.async(execute: {
                self.playerTable.reloadData()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        let cellData = myPlayers[indexPath.row]
        cell.playerName.text = cellData.first_name + " " + cellData.last_name
        cell.playerPrice.text = "$" + cellData.price.description
        cell.playerDetails.text = cellData.nickname + " • " + cellData.year
        cell.playerImage.image = UIImage(named: "IconFrisbeePlayer2")
        if (cellData.image != nil) {
            if let imageData: Data = try? Data(contentsOf: cellData.image!) {
                cell.playerImage.image = UIImage(data: imageData)
            }
        }
        cell.playerOwnedMarker.text = cellData.owned ? "\u{2713}" : ""
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegueWithIdentifier("gotoLineupView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if (myPlayers[indexPath.row].owned) {
            let deletePlayerAction = UITableViewRowAction(style: .default, title: "Drop") { action, index in
                let playerId = self.myPlayers[indexPath.row].id
                APIHandler().makeHTTPRequest("/api/lineups/" + self.myLineupId.description + "/players/" + playerId.description, method: APIHandler.HTTPMethod.delete, data: nil, onCompleted: {
                    (data: AnyObject, response: URLResponse?, error: NSError?) in
                    self.loadData()
                })
            }
            deletePlayerAction.backgroundColor = UIColor(red:0.84, green:0.14, blue:0.14, alpha:1.0)
            
            return [deletePlayerAction]
        } else {
            let addPlayerAction = UITableViewRowAction(style: .default, title: "Add") { action, index in
                let playerId = self.myPlayers[indexPath.row].id
                APIHandler().makeHTTPRequest("/api/lineups/" + self.myLineupId.description + "/players/" + playerId.description, method: APIHandler.HTTPMethod.post, data: nil, onCompleted: {
                    (data: AnyObject, response: URLResponse?, error: NSError?) in
                    let success = data["success"] as! Bool
                    if (success) {
                        self.loadData()
                    } else {
                        let alert = UIAlertController(title: "Could not insert player", message: "Double check that you have sufficient funds for this purhcase", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            addPlayerAction.backgroundColor = UIColor(red:0.00, green:0.50, blue:0.25, alpha:1.0)
            
            return [addPlayerAction]
        }
    }
    
    
    
    // UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

