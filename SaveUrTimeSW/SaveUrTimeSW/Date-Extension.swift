//
//  Date-Extension.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 07/04/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

extension Date {
    
    func getformatString(fromDate: Date, formatPlace: DateFormatPlace) -> String {
        let dtFormat = DateFormatter()
        switch(formatPlace){
            case .newsCell: dtFormat.dateFormat = DateFormats.newsCell
            case .newsArticleDetail: dtFormat.dateFormat = DateFormats.newsArticleDetails
            case .taskDetail: dtFormat.dateFormat = DateFormats.taskDetails
        }
        return dtFormat.string(from: fromDate)
    }
    
    func getformatDateRSS(fromString: String) -> Date? {
        let GMT_ABBREVIATION = "GMT"
        let dtFormat = DateFormatter()
        dtFormat.dateFormat = DateFormats.newsArticleDetails
        dtFormat.timeZone = TimeZone.init(abbreviation: GMT_ABBREVIATION)
        let trimmedStrWithoutGMT = fromString.substring(to: fromString.index(fromString.endIndex, offsetBy: -4))
        return dtFormat.date(from: trimmedStrWithoutGMT)
    }

}
