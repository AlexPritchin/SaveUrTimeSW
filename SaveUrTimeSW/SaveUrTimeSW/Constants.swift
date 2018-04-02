//
//  Constants.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

    let BBC_RSS_URL = "http://feeds.bbci.co.uk/news/world/rss.xml#"
    let BBC_RSS_XML_TAG_ITEM = "item"
    let BBC_RSS_XML_TAG_MEDIATHUMBNAIL = "media:thumbnail"
    let BBC_RSS_XML_TAG_TITLE = "title"
    let BBC_RSS_XML_TAG_DESCRIPTION = "description"
    let BBC_RSS_XML_TAG_LINK = "link"
    let BBC_RSS_XML_TAG_PUBDATE = "pubDate"
    let BBC_RSS_XML_DATETIME_FORMAT = "ccc, d MMM yyyy H:mm:ss"
    let GMT_ABBREVIATION = "GMT"
    let NEWS_CELL_REUSABLE_IDENTIFIER = "NewsCell"
    let NEWS_CELL_DATETIME_FORMAT = "dd/MM/yyyy"
    let NEWS_ARTICLE_VIEW_DATETIME_FORMAT = "ccc, d MMM yyyy H:mm:ss"
    let SEGUE_IDENTIFIER_FROM_NEWS_TABLE_TO_NEWS_ARTICLE = "ToNewsDetails"
    let NEWS_IMAGES_DIR_NAME = "/NewsImages"
    let TASK_DATETIME_FORMAT = "dd/MM/yyyy H:mm:ss"
    let TASK_CELL_REUSABLE_IDENTIFIER = "TaskCell"
    let SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL = "ToTaskDetails"
    let TASK_STATUS_ACTIVE_STR = "active"
    let TASK_STATUS_COMPLETED_STR = "completed"
    let TASK_STATUS_DELETED_STR = "deleted"
    let PLACEHOLDER_TEXT_VIEW_TEXT_CHANGED_ANIMATION_DURATION : Double = 0.1

    enum TaskStatus : Int{
      case TASK_STATUS_ACTIVE = 1
      case TASK_STATUS_COMPLETED = 2
      case TASK_STATUS_DELETED = 3
    }
    
    enum TaskWorkMode : Int{
      case TASK_WORK_MODE_NEW = 0
      case TASK_WORK_MODE_VIEW = 1
      case TASK_WORK_MODE_EDIT = 2
    }
