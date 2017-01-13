//
//  StandingsViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/10/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class StandingsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNumber: UILabel!
    @IBOutlet weak var lineupName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var points: UILabel!
}

class StandingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Properties
    @IBOutlet weak var myStandingsTableView: UITableView!
    @IBOutlet weak var myWeekPicker: UIPickerView!
    
    var myLeague: League = League()
    var myCurrentWeek: Week = Week()
    var myWeeks: Array<Week> = []
    var myStandings: Array<Standing> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myStandingsTableView.delegate = self
        myStandingsTableView.dataSource = self
        
        myWeekPicker.delegate = self
        myWeekPicker.dataSource = self
        
        loadStandings(weekId: myCurrentWeek.id)
        loadWeeks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndex = myStandingsTableView.indexPathForSelectedRow {
            myStandingsTableView.deselectRow(at: selectedIndex, animated: animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStandings.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingsTableViewCell
        let standing = myStandings[indexPath.row]
        
        cell.placeNumber.text = ""
        
        switch (standing.placeNumber) {
        case 1:
            cell.placeImage.image = UIImage(named: "IconGoldMedal")
            cell.placeImage.tintColor = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
            break
        case 2:
            cell.placeImage.image = UIImage(named: "IconSilverMedal")
            cell.placeImage.tintColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
            break
        case 3:
            cell.placeImage.image = UIImage(named: "IconBronzeMedal")
            cell.placeImage.tintColor = UIColor(red:0.80, green:0.50, blue:0.20, alpha:1.0)
            break
        default:
            cell.placeNumber.text = indexPath.row.description
            break
        }
        
        cell.lineupName.text = standing.lineupName
        cell.ownerName.text = standing.ownerName
        cell.points.text = standing.points.description
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myWeeks.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "All Time" : "Week \(myWeeks[row - 1].number)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadStandings(weekId: row == 0 ? nil : myWeeks[row - 1].id)
    }
    
    //MARK: Actions
    
    private func loadStandings(weekId: Int?) {
        APIMethods.getStandings(leagueId: myLeague.id, weekId: weekId, onSuccess: { (standings) in
            self.myStandings = standings
            DispatchQueue.main.async {
                self.myStandingsTableView.reloadData()
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }
    
    private func loadWeeks() {
        APIMethods.getWeeks(leagueId: myLeague.id, onSuccess: { (weeks) in
            self.myWeeks = weeks
            DispatchQueue.main.async {
                self.myWeekPicker.reloadAllComponents()
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }
}
