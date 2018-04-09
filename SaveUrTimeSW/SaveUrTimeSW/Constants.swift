//
//  Constants.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

    let NEWS_IMAGES_DIR_NAME = "/NewsImages"
    let BBC_RSS_URL = "http://feeds.bbci.co.uk/news/world/rss.xml#"

    struct BBCRssXmlTags{
        static let item = "item"
        static let mediaThumbnail = "media:thumbnail"
        static let title = "title"
        static let description = "description"
        static let link = "link"
        static let pubDate = "pubDate"
    }

    struct DateFormats {
        static let newsCell = "dd/MM/yyyy"
        static let newsArticleDetails = "ccc, d MMM yyyy H:mm:ss"
        static let taskDetails = "dd/MM/yyyy H:mm:ss"
    }

    enum DateFormatPlace : String{
        case newsCell, newsArticleDetail, taskDetail
    }

    struct TaskStatusStr{
        static let active = "active"
        static let completed = "completed"
    }

    enum TaskStatus : Int{
        case active = 1, completed = 2, deleted = 3
    }
    
    enum TaskWorkMode : String{
      case undefined, new, view, edit
    }
