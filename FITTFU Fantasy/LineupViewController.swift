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

    var myLeague: League = League()
    var myLineup: Lineup = Lineup()
    var myPlayers: Array<Player> = []
    
    //MARK: Properties
    
    @IBOutlet weak var lineupNameLabel: UILabel!
    @IBOutlet weak var lineupMoneyRemainingLabel: UILabel!
    @IBOutlet weak var lineupMoneyRemainingProgress: UIProgressView!
    @IBOutlet weak var playerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerTable.delegate = self
        playerTable.dataSource = self
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"reloadLineup"), object:nil, queue:nil) {
            notification in
            self.loadData()
        }
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoPlayerInfoView") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationViewController = destinationNavigationController.viewControllers[0] as! PlayerInfoViewController
            let sourceIndexPath = sender as! IndexPath
            destinationViewController.myPlayer.id = myPlayers[sourceIndexPath.row].id
            destinationViewController.myLineup = myLineup
            destinationViewController.myLeague = myLeague
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        let player = myPlayers[indexPath.row]
        cell.playerName.text = player.name
        cell.playerPrice.text = "$\(player.price)"
        cell.playerDetails.text = "\(player.nickname) • \(player.year)"
        cell.playerImage.image = UIImage(named: "IconDefaultProfile")
        if (player.image != nil) {
            if let imageData: Data = try? Data(contentsOf: player.image!) {
                cell.playerImage.image = UIImage(data: imageData)
            }
        }
        
        cell.playerOwnedMarker.text = player.owned ? "\u{2713}" : ""
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegueWithIdentifier("gotoLineupView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let player = self.myPlayers[indexPath.row]
        let playerAction = UITableViewRowAction(style: .default, title: (player.owned ? "Drop" : "Add")) { (action, index) in
            if (player.owned) {
                APIMethods.removePlayer(lineupId: self.myLineup.id, playerId: player.id, onSuccess: {
                    self.loadData()
                }, onError: { (error) in
                    print(error)
                })
            } else {
                APIMethods.addPlayer(lineupId: self.myLineup.id, playerId: player.id, onSuccess: {
                    self.loadData()
                }, onError: { (error) in
                    let alert = UIAlertController(title: "Could not insert player", message: "Double check that you have sufficient funds for this purhcase", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
        playerAction.backgroundColor = (player.owned) ?
            UIColor(red:0.84, green:0.14, blue:0.14, alpha:1.0) :
            UIColor(red:0.00, green:0.50, blue:0.25, alpha:1.0)
        
        return [playerAction]
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoPlayerInfoView", sender: indexPath)
    }
    
    // UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Private Functions:
    func loadData() {
        APIMethods.getLineup(lineupId: myLineup.id, onSuccess: { (lineup) in
            self.myLineup = lineup
            DispatchQueue.main.async {
                self.lineupNameLabel.text = self.myLineup.name
                self.lineupMoneyRemainingLabel.text = "$\(self.myLineup.moneyLeft) of $\(self.myLineup.moneyTotal) left"
                self.lineupMoneyRemainingProgress.progress = self.myLineup.fractionMoneySpent
            }
        }, onError: { (error) in
            print(error)
        })
        
        APIMethods.getPlayers(lineupId: myLineup.id, onSuccess: { (players) in
            self.myPlayers = players
            DispatchQueue.main.async(execute: {
                self.playerTable.reloadData()
            })
        }, onError: { (error) in
            print(error)
        })
    }
}

