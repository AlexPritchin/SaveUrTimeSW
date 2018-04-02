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
        let downloadTask = URLSession.shared.dataTask(with: URL.init(string: BBC_RSS_URL)!, completionHandler:{(data, response, error) -> Void in
            self.delegate?.didFinishRSSDownloading(rssData: data!)
            })
        downloadTask.resume()
    }
}
