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
    
    struct Player {
        var id: Int = -1
        var firstName: String = "First"
        var lastName: String = "Last"
        var price: Int = 0
        var image: URL?
        var nickname: String = "Nickname"
        var year: String = "Year"
        var owned: Bool = false
    }
    
    struct StatsCategory {
        var name: String
        var value: Int
        var count: Int
    }
    
    struct WeeklyPlayerStats {
        var weekId: Int
        var weekNumber: Int
        var pointTotal: Int
        var categories: Array<StatsCategory>
    }
    
    var myLeagueId: Int = -1
    var myLineupId: Int = -1
    var myPlayer: Player = Player()
    var myPlayerStats: Array<WeeklyPlayerStats> = []
    
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
    
    
    //Collection view data source functions:
    
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
            //Regular old value cell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerStatsValueCell", for: indexPath) as! PlayerStatsCollectionViewValueCell
            if (col == 1) {
                cell.myValue.text = myPlayerStats[row - 1].pointTotal.description
                cell.myValue.font = UIFont.boldSystemFont(ofSize: 20.0)
            } else {
                cell.myValue.text = myPlayerStats[row - 1].categories[col - 2].value.description
                cell.myValue.font = UIFont.systemFont(ofSize: 18.0)
            }
            cell.backgroundColor = (row % 2 == 0) ? UIColor.gray : UIColor.white
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
        if (myPlayer.owned) {
            //Delete player:
            APIHandler().makeHTTPRequest("/api/lineups/" + self.myLineupId.description + "/players/" + myPlayer.id.description, method: APIHandler.HTTPMethod.delete, data: nil, onCompleted: {
                (data: AnyObject, response: URLResponse?, error: NSError?) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLineup"), object: nil)
                self.loadPlayerInfo()
            })
        } else {
            //Add player:
            APIHandler().makeHTTPRequest("/api/lineups/" + self.myLineupId.description + "/players/" + myPlayer.id.description, method: APIHandler.HTTPMethod.post, data: nil, onCompleted: {
                (data: AnyObject, response: URLResponse?, error: NSError?) in
                let success = data["success"] as! Bool
                if (success) {
                    self.loadPlayerInfo()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadLineup"), object: nil)
                } else {
                    let alert = UIAlertController(title: "Could not insert player", message: "Double check that you have sufficient funds for this purhcase", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func onCancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    //Private functions
    private func loadPlayerInfo() {
        APIHandler().makeHTTPRequest("/api/players/\(myPlayer.id)?lineup_id=\(myLineupId)", method: APIHandler.HTTPMethod.get, data: nil) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                let playerData = data["player"] as! [String:Any]
                self.myPlayer = Player(
                    id: playerData["id"] as! Int,
                    firstName: playerData["first_name"] as! String,
                    lastName: playerData["last_name"] as! String,
                    price: playerData["price"] as! Int,
                    image: nil,
                    nickname: playerData["nickname"] as! String,
                    year: playerData["year"] as! String,
                    owned: playerData["owned"] as! Bool
                )
                if let playerImage = playerData["image"] as? String {
                    self.myPlayer.image = URL(string: playerImage)
                }
                
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
                    
                    if (p.owned) {
                        self.myEditLineupButton.setTitle("Drop", for: .normal)
                        self.myEditLineupButton.myCurrentTheme = Themes.danger
                    } else {
                        self.myEditLineupButton.setTitle("Add", for: .normal)
                        self.myEditLineupButton.myCurrentTheme = Themes.success
                    }
                }
            } else {
                
            }
        }
        APIHandler().makeHTTPRequest("/api/players/\(myPlayer.id)/weeklyStats?league_id=\(myLeagueId)", method: APIHandler.HTTPMethod.get, data: nil) {
            (data, response, error) in
            self.myPlayerStats = []

            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                print(data)
                let stats = data["stats"] as! [[String: Any]]
                for week in stats {
                    var categories: Array<StatsCategory> = []
                    for category in week["categories"] as! [[String: Any]] {
                        categories.append(StatsCategory(
                            name: category["name"] as! String,
                            value: category["value"] as! Int,
                            count: category["count"] as! Int
                        ))
                    }
                    
                    self.myPlayerStats.append(WeeklyPlayerStats(
                        weekId: week["week_id"] as! Int,
                        weekNumber: week["week_number"] as! Int,
                        pointTotal: week["point_total"] as! Int,
                        categories: categories
                    ))
                }
                DispatchQueue.main.async {
                    self.myPlayerStatsCollection.reloadData()
                }
                
            } else {
                
            }
            
        }
    }
    
}
