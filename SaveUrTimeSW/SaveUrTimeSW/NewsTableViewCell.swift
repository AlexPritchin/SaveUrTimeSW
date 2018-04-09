//
//  NewsTableViewCell.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pubDateLabel.text = ""
        self.titleLabel.text = ""
        self.thumbnailImageView.image = nil
    }
    
    func loadData(articleForLoadData:NewsArticle){
        guard let artForLoadDataPubDt = articleForLoadData.pubDate else{
            return
        }
        self.pubDateLabel.text = Date().getformatString(fromDate: artForLoadDataPubDt, formatPlace: DateFormatPlace.newsCell)
        guard let artForLoadDataTtl = articleForLoadData.title else {
            return
        }
        self.titleLabel.text = artForLoadDataTtl
        guard let artForLoadDataThumb = articleForLoadData.thumbnail else {
            return
        }
        DispatchQueue.global().async {
            let image = UIImage.init(data: ImageWorker.getImageForUrl(webURL: artForLoadDataThumb))
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }

}
