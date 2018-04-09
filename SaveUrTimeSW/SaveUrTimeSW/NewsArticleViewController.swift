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
        if let artToDisplay = articleToDisplay {
            if let artToDisplayTtl = artToDisplay.title {
                self.titleLabel.text = artToDisplayTtl
            }
            if let artToDisplaypPubDT = artToDisplay.pubDate {
                self.pubDateLabel.text = Date().getformatString(fromDate: artToDisplaypPubDT, formatPlace: DateFormatPlace.newsArticleDetail)
            }
            if let artToDisplayThumb = artToDisplay.thumbnail {
                self.thumbnailImageView.image = UIImage.init(data: ImageWorker.getImageForUrl(webURL: artToDisplayThumb))
            }
            if let artToDisplayDescr = artToDisplay.descript {
                self.descriptionLabel.text = artToDisplayDescr
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func urlButtonTouched(_ sender: Any) {
        if let artToDisplay = articleToDisplay {
            if let artToDisplayLnk = artToDisplay.link {
                UIApplication.shared.open(URL.init(string: artToDisplayLnk)!, options: [:], completionHandler:nil)
            }
        }
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
