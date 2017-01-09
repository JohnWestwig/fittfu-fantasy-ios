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
    
    var myLeague: League = League()
    var myCurrentWeek: Week = Week()
    var myLineup: Lineup = Lineup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeek()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoLineupView") {
            let destinationLineupView = segue.destination as! LineupViewController
            destinationLineupView.myLineup = myLineup
            destinationLineupView.myLeague = myLeague
        }
    }
    
    //MARK: Actions
    
    @IBAction func myLineupViewClicked(_ sender: Any) {
        //Do nothing, handled by segue.
    }
    
    private func getCurrentWeek() {
        APIMethods.getCurrentWeek(leagueId: myLeague.id, onSuccess: { (week) in
            self.myCurrentWeek = week
            DispatchQueue.main.async {
                self.myCurrentWeekLabel.text = "Week \(self.myCurrentWeek.number)"
                self.myLineupEditingMessageLabel.text = self.myCurrentWeek.canEdit ? "Available for editing until \(self.myCurrentWeek.editEnd)" : "Unavailable for editing at this time"
            }
            self.loadLineup()
        }, onError: { (error) in
            print(error)
        })
    }
    
    private func loadLineup() {
        APIMethods.getMyLineup(weekId: myCurrentWeek.id, onSuccess: { (lineup) in
            self.myLineup = lineup
            DispatchQueue.main.async {
                self.myLineupNameLabel.text = self.myLineup.name
            }
        }) { (error) in
            print(error)
        }
    }
}

