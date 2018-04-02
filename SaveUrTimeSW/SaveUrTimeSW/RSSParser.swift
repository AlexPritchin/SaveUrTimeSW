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
        if elemName == BBC_RSS_XML_TAG_ITEM {
            isInsideItem = true
            isElementEnd = true
            foundItem = NewsArticle()
        }
        else if elemName == BBC_RSS_XML_TAG_MEDIATHUMBNAIL {
            foundItem.thumbnail = URL.init(string: attributeDict["url"]!)
        }
        else {
            isElementEnd = false
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == BBC_RSS_XML_TAG_ITEM {
            isInsideItem = false
            rssArray.append(foundItem)
        }
        isElementEnd = true
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isInsideItem {
            if !isElementEnd {
                let trimmedStr = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if elemName == BBC_RSS_XML_TAG_TITLE {
                    foundItem.title = trimmedStr
                }
                else if elemName == BBC_RSS_XML_TAG_DESCRIPTION {
                    foundItem.descript = trimmedStr
                }
                else if elemName == BBC_RSS_XML_TAG_LINK {
                    foundItem.link = trimmedStr
                }
                else if elemName == BBC_RSS_XML_TAG_PUBDATE {
                    let dtFormat = DateFormatter()
                    dtFormat.dateFormat = BBC_RSS_XML_DATETIME_FORMAT
                    dtFormat.timeZone = TimeZone.init(abbreviation: GMT_ABBREVIATION)
                    let trimmedStrWithoutGMT = trimmedStr.substring(to: trimmedStr.index(trimmedStr.endIndex, offsetBy: -4))
                    foundItem.pubDate = dtFormat.date(from: trimmedStrWithoutGMT)
                }
            }
        }
    }
}

