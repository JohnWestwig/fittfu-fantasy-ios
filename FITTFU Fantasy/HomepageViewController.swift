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
        
        
        
        print(self.navigationController)
        
        APIHandler().makeHTTPRequest("/api/lineups", method: APIHandler.HTTPMethod.GET, data: nil, onCompleted: {
            (data: AnyObject, response: NSURLResponse?, error: NSError?) in
            let lineups = data["lineups"] as! [AnyObject]
            for lineup in lineups {
                let lineupId = lineup["id"] as! Int
                let lineupName = lineup["name"] as! String
                self.myLineups.append(lineupItem(id: lineupId, name: lineupName))
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.lineupTable.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //test
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)   {
        if (segue.identifier == "gotoLineupView") {
            let destinationLineupView = segue.destinationViewController as! LineupViewController
            let indexPath = self.lineupTable.indexPathForSelectedRow
            destinationLineupView.myLineupId = self.myLineups[indexPath!.row].id
            destinationLineupView.myLineupName = self.myLineups[indexPath!.row].name
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLineups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lineupCell", forIndexPath: indexPath) as! LineupTableViewCell
        cell.lineupName.text = myLineups[indexPath.row].name
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotoLineupView", sender: nil)
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Actions
    

    
}

