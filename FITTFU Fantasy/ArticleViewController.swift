//
//  ArticleViewController.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/11/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myAuthorLabel: UILabel!
    @IBOutlet weak var myDatePublishedLabel: UILabel!
    @IBOutlet weak var myContentLabel: UILabel!
    @IBOutlet weak var myNavigationItem: UINavigationItem!
    
    var myArticle: Article = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func myDoneButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func loadArticle () {
        APIMethods.getArticle(articleId: myArticle.id, onSuccess: { (article) in
            self.myArticle = article
            DispatchQueue.main.async {
                self.myTitleLabel.text = self.myArticle.title
                self.myAuthorLabel.text = self.myArticle.author
                self.myDatePublishedLabel.text = self.myArticle.datePublishedShort
                self.myContentLabel.text = self.myArticle.content
            }
        }, onError: { (error) in
            print(error)
        }, senderView: self.view)
    }

}
