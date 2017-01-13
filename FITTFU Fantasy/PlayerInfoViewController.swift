//
//  PlayerInfoViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/4/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class PlayerStatsCollectionViewTitleCell : UICollectionViewCell {
    @IBOutlet weak var myValue: UILabel!
}

class PlayerStatsCollectionViewHeaderCell: UICollectionViewCell {
    @IBOutlet weak var myCategory: UILabel!
    @IBOutlet weak var myMultiplier: UILabel!
    
    override func awakeFromNib() {
        myMultiplier.layer.cornerRadius = 4
        myMultiplier.clipsToBounds = true
    }
}

class PlayerStatsCollectionViewSidebarCell : UICollectionViewCell {
    @IBOutlet weak var myValue: UILabel!
}

class PlayerStatsCollectionViewValueCell : UICollectionViewCell {
    @IBOutlet weak var myValue: UILabel!

}

class PlayerInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myLeague: League = League()
    var myLineup: Lineup = Lineup()
    var myPlayer: Player = Player()
    var myPlayerStats: Array<WeeklyStats> = []
    
    //MARK: Properties
    @IBOutlet weak var myPlayerImage: UIImageViewRounded!
    @IBOutlet weak var myPlayerPrice: UILabel!
    @IBOutlet weak var myPlayerName: UILabel!
    @IBOutlet weak var myPlayerDetails: UILabel!
    @IBOutlet weak var myPlayerTeam: UILabel!
    @IBOutlet weak var myEditLineupButton: UIButtonPrimary!
    
    @IBOutlet weak var myPlayerStatsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPlayerStatsCollection.delegate = self
        myPlayerStatsCollection.dataSource = self
        
        loadPlayerInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return myPlayerStats.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPlayerStats.count > 0 ? myPlayerStats[0].categories.count + 2 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.section
        let col = indexPath.item
        
        if (row != 0 && col != 0) {
            print(row, col)
            //Regular old value cell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerStatsValueCell", for: indexPath) as! PlayerStatsCollectionViewValueCell
            if (col == 1) {
                cell.myValue.text = myPlayerStats[row - 1].total.description
                cell.myValue.font = UIFont.boldSystemFont(ofSize: 20.0)
            } else {
                cell.myValue.text = myPlayerStats[row - 1].categories[col - 2].count.description
                cell.myValue.font = UIFont.systemFont(ofSize: 18.0)
            }
            cell.backgroundColor = (row % 2 == 0) ? UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0) : UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
            return cell
        } else if (row != 0 && col == 0) {
            //Sidebar cell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerStatsSidebarCell", for: indexPath) as! PlayerStatsCollectionViewSidebarCell
            cell.myValue.text = "Week \(myPlayerStats[row - 1].weekNumber)"
            return cell
        } else if (row == 0 && col != 0) {
            //Header cell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"playerStatsHeaderCell", for: indexPath) as! PlayerStatsCollectionViewHeaderCell
            cell.myCategory.text = (col == 1) ? "Total" : myPlayerStats[0].categories[col - 2].name
            cell.myMultiplier.text = (col == 1) ? "" : " X\(myPlayerStats[0].categories[col - 2].value) "
            return cell
        } else {
            //Title cell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerStatsTitleCell", for: indexPath) as! PlayerStatsCollectionViewTitleCell
            cell.myValue.text = "STATS"
            return cell
        }
    }
    
    //Collection view delegate functions:

    
    //MARK: Actions
    
    @IBAction func onLineupChangeClicked(_ sender: UIButton) {
        let errorResponse: (APIError) -> Void = { (error) in
            let alert = UIAlertController(title: error.message, message: error.details, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (myPlayer.owned) {
            APIMethods.removePlayer(lineupId: myLineup.id, playerId: myPlayer.id, onSuccess: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLineup"), object: nil)
                self.loadPlayerInfo()
            }, onError: { (error) in
                errorResponse(error)
            }, senderView: self.view)
        } else {
            APIMethods.addPlayer(lineupId: myLineup.id, playerId: myPlayer.id, onSuccess: {
                self.loadPlayerInfo()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLineup"), object: nil)
            }, onError: { (error) in
                errorResponse(error)
            }, senderView: self.view)
        }
    }
    
    @IBAction func onCancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    //Private functions
    private func loadPlayerInfo() {
        APIMethods.getPlayer(playerId: myPlayer.id, lineupId: myLineup.id, onSuccess: { (player) in
            self.myPlayer = player
            DispatchQueue.main.async() {
                let p = self.myPlayer
                self.myPlayerName.text = "\(p.firstName) \(p.lastName)"
                self.myPlayerDetails.text = "\(p.nickname) • \(p.year)"
                self.myPlayerPrice.text = "$\(p.price)"
                self.myPlayerImage.image = UIImage(named: "IconDefaultProfile")
                if (p.image != nil) {
                    if let imageData: Data = try? Data(contentsOf: p.image!) {
                        self.myPlayerImage.image = UIImage(data: imageData)
                    }
                }
                self.myPlayerTeam.text = p.teamName
                self.myEditLineupButton.setTitle(p.owned ? "Drop" : "Add", for: .normal)
                self.myEditLineupButton.myCurrentTheme = p.owned ? Themes.danger : Themes.success
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
        
        APIMethods.getPlayerStats(playerId: myPlayer.id, leagueId: myLeague.id, onSuccess: { (weeklyStats) in
            self.myPlayerStats = weeklyStats
            print(self.myPlayerStats)
            DispatchQueue.main.async {
                self.myPlayerStatsCollection.reloadData()
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }
    
}
