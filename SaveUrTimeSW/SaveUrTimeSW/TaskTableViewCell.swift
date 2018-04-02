//
//  TaskTableViewCell.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        self.modifiedDateLabel.text = ""
        self.titleLabel.text = ""
    }
    
    func loadData(taskForLoadData: Task){
        self.modifiedDateLabel.text = taskForLoadData.modifiedDate
        self.titleLabel.text = taskForLoadData.title
        if taskForLoadData.status! == TaskStatus.TASK_STATUS_COMPLETED.rawValue {
                self.setLabelsTextStrikeout()
        }
    }
    
    func setLabelsTextStrikeout(){
        let strikeoutTextDate = NSMutableAttributedString.init(string: self.modifiedDateLabel.text!)
        strikeoutTextDate.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, strikeoutTextDate.length))
        self.modifiedDateLabel.attributedText = strikeoutTextDate
        let strikeoutTextTitle = NSMutableAttributedString.init(string: self.titleLabel.text!)
        strikeoutTextTitle.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, strikeoutTextTitle.length))
        self.titleLabel.attributedText = strikeoutTextTitle
    }

}
