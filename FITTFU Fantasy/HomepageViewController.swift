//
//  HomepageViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 01/01/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet weak var myLineupNameLabel: UILabel!
    @IBOutlet weak var myCurrentWeekLabel: UILabel!
    @IBOutlet weak var myLineupEditingMessageLabel: UILabel!
    
    struct Week {
        var id: Int
        var number: Int
    }
    
    var myLeagueId: Int = -1
    var myWeek: Week?
    var myLineupId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIHandler().makeHTTPRequest("/api/leagues/" + myLeagueId.description + "/weeks/current", method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                let week = data["week"] as! [String:AnyObject]
                self.myWeek = Week(
                    id: week["id"] as! Int,
                    number: week["number"] as! Int
                )
                
                DispatchQueue.main.async {
                    self.myCurrentWeekLabel.text = "Week " + self.myWeek!.number.description
                    self.myLineupEditingMessageLabel.text = week["can_edit"] as! Int == 1 ? "Available for editing" : "Unavailable for editing at this time"
                }

                self.loadLineup()
            } else {
                //TODO: error handling
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoLineupView") {
            let destinationLineupView = segue.destination as! LineupViewController
            destinationLineupView.myLineupId = myLineupId
            destinationLineupView.myLeagueId = myLeagueId
        }
        //More segues here
    }
    
    //MARK: Actions
    
    @IBAction func myLineupViewClicked(_ sender: Any) {
        //Do nothing, handled by segue.
    }
    
    private func loadLineup() {
        APIHandler().makeHTTPRequest("/api/weeks/" + myWeek!.id.description + "/lineups/me", method: APIHandler.HTTPMethod.get, data: nil, onCompleted: {
            (data: AnyObject, response: URLResponse?, error: NSError?) in
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                let lineup = data["lineup"] as! [String: AnyObject]
                self.myLineupId = lineup["id"] as! Int
                DispatchQueue.main.async {
                    self.myLineupNameLabel.text = lineup["name"] as! String?
                }
            } else {
                //TODO: error handling
            }
        })
    }
}

