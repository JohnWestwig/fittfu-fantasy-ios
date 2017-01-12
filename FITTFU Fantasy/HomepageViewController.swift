//
//  HomepageViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 01/01/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class ArticleTableViewCell : UITableViewCell {
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleContentLabel: UILabel!
}

class HomepageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    
    @IBOutlet weak var myArticleTableView: UITableView!
    
    var myLeague: League = League()
    var myCurrentWeek: Week = Week()
    var myLineup: Lineup = Lineup()
    var myArticles: Array<Article> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myArticleTableView.delegate = self
        myArticleTableView.dataSource = self
        
        getCurrentWeek()
        loadArticles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)   {
        if (segue.identifier == "gotoLineupView") {
            let destinationLineupView = segue.destination as! LineupViewController
            destinationLineupView.myLineup = myLineup
            destinationLineupView.myLeague = myLeague
        } else if (segue.identifier == "gotoStandingsView") {
            let destinationStandingsView = segue.destination as! StandingsViewController
            destinationStandingsView.myLeague = myLeague
            destinationStandingsView.myCurrentWeek = myCurrentWeek
        } else if (segue.identifier == "gotoArticleView") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationArticleView = destinationNavigationController.topViewController as! ArticleViewController
            destinationArticleView.myArticle = myArticles[myArticleTableView.indexPathForSelectedRow!.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        let article = myArticles[indexPath.row]
        cell.articleNameLabel.text = article.title
        cell.articleAuthorLabel.text = article.author
        cell.articleDateLabel.text = article.datePublishedShort
        cell.articleContentLabel.text = article.content
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoArticleView", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: Actions
    
    @IBAction func myStandingsButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoStandingsView", sender: sender)
    }
    @IBAction func myLineupButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoLineupView", sender: sender)
    }
    
    
    private func getCurrentWeek() {
        APIMethods.getCurrentWeek(leagueId: myLeague.id, onSuccess: { (week) in
            self.myCurrentWeek = week
            self.loadLineup()
        }, onError: { (error) in
            print(error)
        })
    }
    
    private func loadLineup() {
        APIMethods.getMyLineup(weekId: myCurrentWeek.id, onSuccess: { (lineup) in
            self.myLineup = lineup
        }) { (error) in
            print(error)
        }
    }
    
    private func loadArticles() {
        APIMethods.getArticles(leagueId: myLeague.id, onSuccess: { (articles) in
            self.myArticles = articles
            DispatchQueue.main.async {
                self.myArticleTableView.reloadData()
            }
        }, onError: { (error) in
            print(error)
        })
    }
}

