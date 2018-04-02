//
//  NewsDataWorker.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

protocol NewsDataWorkerDelegate {
    func didFinishDataInitialization(rssDataArray : [NewsArticle])
}

class NewsDataWorker: NSObject, RSSDownloaderDelegate {
    
    var delegate : NewsDataWorkerDelegate?
    
    func initializeData(){
        DispatchQueue.global().async {
            let rssDataDownloader = RSSDownloader()
            rssDataDownloader.delegate = self
            rssDataDownloader.getRssDataForParse()
        }
    }
    
    func didFinishRSSDownloading(rssData : Data){
        let rssDataParser = RSSParser()
        let parsedRssArray : [NewsArticle] = rssDataParser.parseRssFromData(rssData: rssData)
        DispatchQueue.main.async {
            self.delegate?.didFinishDataInitialization(rssDataArray: parsedRssArray)
        }
    }

}
