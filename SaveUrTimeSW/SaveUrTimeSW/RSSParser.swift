//
//  RSSParser.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class RSSParser: NSObject, XMLParserDelegate {
    
    private var rssArray : [NewsArticle]
    private var foundItem : NewsArticle
    private var elemName : String
    private var isInsideItem, isElementEnd : Bool
    
    override init(){
        self.isInsideItem = false
        self.isElementEnd = true
        self.rssArray = [NewsArticle]()
        self.foundItem = NewsArticle()
        self.elemName = ""
        super.init()
    }
    
    func parseRssFromData(rssData : Data) -> [NewsArticle]{
        let rssParser = XMLParser.init(data: rssData)
        rssParser.delegate = self
        rssParser.parse()
        return rssArray
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        elemName = elementName
        if elemName == BBCRssXmlTags.item {
            isInsideItem = true
            isElementEnd = true
            foundItem = NewsArticle()
        }
        else if elemName == BBCRssXmlTags.mediaThumbnail {
            if let urlAttribute = attributeDict["url"] {
                foundItem.thumbnail = URL.init(string: urlAttribute)
            }
        }
        else {
            isElementEnd = false
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == BBCRssXmlTags.item {
            isInsideItem = false
            rssArray.append(foundItem)
        }
        isElementEnd = true
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isInsideItem {
            if !isElementEnd {
                let trimmedStr = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                switch elemName {
                    case BBCRssXmlTags.title: foundItem.title = trimmedStr
                    case BBCRssXmlTags.description: foundItem.descript = trimmedStr
                    case BBCRssXmlTags.link: foundItem.link = trimmedStr
                    case BBCRssXmlTags.pubDate: foundItem.pubDate = Date().getformatDateRSS(fromString: trimmedStr)
                    default : break
                }
            }
        }
    }
}

