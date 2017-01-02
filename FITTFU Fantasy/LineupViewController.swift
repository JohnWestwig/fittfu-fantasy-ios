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
}

class LineupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    struct playerItem {
        var id: Int
        var price: Int
        var first_name: String
        var last_name: String
        var year: String
        var nickname: String
        var image: NSURL?
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
        APIHandler().makeHTTPRequest("/api/lineups/" + myLineupId.description, method: APIHandler.HTTPMethod.GET, data: nil, onCompleted: {
            (data: AnyObject, response: NSURLResponse?, error: NSError?) in
            let lineup = data["lineup"] as! [String:AnyObject]
            self.myLineupName = lineup["name"] as! String
            self.myLineupMoneyTotal = lineup["money_total"] as! Int
            self.myLineupMoneySpent = lineup["money_spent"] as! Int
            
            dispatch_async(dispatch_get_main_queue(), {
                self.lineupMoneyRemainingLabel.text = "$" + (self.myLineupMoneyTotal - self.myLineupMoneySpent).description + " of $" + self.myLineupMoneyTotal.description + " remaining"
                self.lineupMoneyRemainingProgress.progress = Float(self.myLineupMoneySpent) / Float(self.myLineupMoneyTotal)
            })
        })
        
        APIHandler().makeHTTPRequest("/api/lineups/" + myLineupId.description + "/players", method: APIHandler.HTTPMethod.GET, data: nil, onCompleted: {
            (data: AnyObject, response: NSURLResponse?, error: NSError?) in
            let players = data["players"] as! [AnyObject]
            self.myPlayers = []
            for player in players {
                let playerId = player["id"] as! Int
                let playerFirstName = player["first_name"] as! String
                let playerLastName = player["last_name"] as! String
                let playerPrice = player["price"] as! Int
                let playerYear = player["year"] as! String
                let playerNickname = player["nickname"] as! String
                if let playerImage = player["image"] as? String {
                    let playerImageUrl = NSURL(string: playerImage)
                    self.myPlayers.append(playerItem(id: playerId, price: playerPrice, first_name: playerFirstName, last_name: playerLastName, year: playerYear, nickname: playerNickname, image: playerImageUrl))
                } else {
                    self.myPlayers.append(playerItem(id: playerId, price: playerPrice, first_name: playerFirstName, last_name: playerLastName, year: playerYear, nickname: playerNickname, image: nil))
                }

            }
            dispatch_async(dispatch_get_main_queue(), {
                self.playerTable.reloadData()
            })
            print(self.myPlayers)
        })
        
        lineupNameLabel.text = myLineupName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlayers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playerCell", forIndexPath: indexPath) as! PlayerTableViewCell
        let cellData = myPlayers[indexPath.row]
        cell.playerName.text = cellData.first_name + " " + cellData.last_name
        cell.playerPrice.text = "$" + cellData.price.description
        cell.playerDetails.text = cellData.nickname + " • " + cellData.year
        if (cellData.image != nil) {
            if let imageData: NSData = NSData(contentsOfURL: cellData.image!) {
                print("Yep")
                cell.playerImage.image = UIImage(data: imageData)
            } else {
                print("Nope")
            }
            print(cellData.image)

        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("gotoLineupView", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            print ("DELETING")
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deletePlayerAction = UITableViewRowAction(style: .Destructive, title: "Drop") { action, index in
            print("Player drop button clicked")
            let playerId = self.myPlayers[indexPath.row].id
            APIHandler().makeHTTPRequest("/api/lineups/" + self.myLineupId.description + "/players/" + playerId.description, method: APIHandler.HTTPMethod.DELETE, data: nil, onCompleted: {
                (data: AnyObject, response: NSURLResponse?, error: NSError?) in
                print(data)
                self.loadData()
            })
        }
        deletePlayerAction.backgroundColor = UIColor.redColor()
        
        return [deletePlayerAction]
    }
    
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
}

