//
//  RSSDownloader.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

protocol RSSDownloaderDelegate {
    func didFinishRSSDownloading(rssData : Data)
}

class RSSDownloader: NSObject {
    
    var delegate : RSSDownloaderDelegate?
    
    func getRssDataForParse(){
        let bbcUrl = URL.init(string: BBC_RSS_URL)
        guard let bbcRssUrl = bbcUrl else {
            return
        }
        let downloadTask = URLSession.shared.dataTask(with: bbcRssUrl, completionHandler:{(data, response, error) -> Void in
            if let downloadedData = data {
                self.delegate?.didFinishRSSDownloading(rssData: downloadedData)
            }
            })
        downloadTask.resume()
    }
}
