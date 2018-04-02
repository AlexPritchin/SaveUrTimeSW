//
//  NewsArticleViewController.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class NewsArticleViewController: UIViewController {

    var articleToDisplay : NewsArticle?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dtFormat = DateFormatter()
        dtFormat.dateFormat = NEWS_ARTICLE_VIEW_DATETIME_FORMAT
        
        self.titleLabel.text = self.articleToDisplay!.title
        self.pubDateLabel.text = dtFormat.string(from: self.articleToDisplay!.pubDate!)
        self.thumbnailImageView.image = UIImage.init(data: ImageWorker.getImageForUrl(webURL: self.articleToDisplay!.thumbnail!))
        self.descriptionLabel.text = self.articleToDisplay!.descript
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func urlButtonTouched(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: self.articleToDisplay!.link!)!, options: [:], completionHandler:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
