//
//  ViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 01/01/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class LineupTableViewCell : UITableViewCell {
    @IBOutlet weak var lineupName: UILabel!
}

class HomepageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct lineupItem {
        var id: Int
        var name: String
        init (id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    var myLineups: Array<lineupItem> = []
    
    //MARK: Properties
    @IBOutlet weak var lineupTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lineupTable.delegate = self
        lineupTable.dataSource = self
        
        APIHandler().makeHTTPRequest("/api/lineups", method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let lineups = data["lineups"] as! [AnyObject]
            for lineup in lineups {
                let lineupId = lineup["id"] as! Int
                let lineupName = lineup["name"] as! String
                self.myLineups.append(lineupItem(id: lineupId, name: lineupName))
            }
            DispatchQueue.main.async(execute: {
                self.lineupTable.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //test
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoLineupView") {
            let destinationLineupView = segue.destination as! LineupViewController
            let indexPath = self.lineupTable.indexPathForSelectedRow
            destinationLineupView.myLineupId = self.myLineups[indexPath!.row].id
            destinationLineupView.myLineupName = self.myLineups[indexPath!.row].name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLineups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lineupCell", for: indexPath) as! LineupTableViewCell
        cell.lineupName.text = myLineups[indexPath.row].name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoLineupView", sender: nil)
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Actions
    

    
}

