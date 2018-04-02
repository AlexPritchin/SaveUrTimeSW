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
        let dtFormat = DateFormatter()
        dtFormat.dateFormat = NEWS_CELL_DATETIME_FORMAT
        
        self.pubDateLabel.text = dtFormat.string(from: articleForLoadData.pubDate!)
        self.titleLabel.text = articleForLoadData.title
        DispatchQueue.global().async {
            let image = UIImage.init(data: ImageWorker.getImageForUrl(webURL: articleForLoadData.thumbnail!))
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }

}
