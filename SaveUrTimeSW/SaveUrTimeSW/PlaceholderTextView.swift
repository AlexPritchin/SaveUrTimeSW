//
//  PlaceholderTextView.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceholderTextView: UITextView {

    @IBInspectable public var placeholderText: String?
    @IBInspectable public var placeholderColor: UIColor?
    
    private var placeholder: UILabel?
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.placeholderText == nil {
            self.placeholderText = ""
        }
        if self.placeholderColor == nil {
            self.placeholderColor = UIColor.lightGray
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    /*init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholderText = ""
        self.placeholderColor = UIColor.lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        self.placeholderText = ""
        self.placeholderColor = UIColor.lightGray
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    func textChanged(notification: NSNotification?){
        if self.placeholderText!.characters.count == 0 {
            return;
        }
    
        UIView.animate(withDuration: PLACEHOLDER_TEXT_VIEW_TEXT_CHANGED_ANIMATION_DURATION, animations:{() -> Void in
            if self.viewWithTag(999) != nil{
                if self.text.characters.count == 0{
                    self.viewWithTag(999)!.alpha = 1
                }
                else {
                    self.viewWithTag(999)!.alpha = 0
                }
            }
        })
    }
    
    override public var text: String!{
        didSet{
            self.textChanged(notification: nil)
        }
    }

    override func draw(_ rect: CGRect) {
        if self.placeholderText!.characters.count > 0 {
            if self.placeholder == nil {
                self.placeholder = UILabel.init(frame: CGRect(x: 8, y: 8, width: self.bounds.size.width - 16, height:0))
                self.placeholder!.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.placeholder!.numberOfLines = 0
                self.placeholder!.font = self.font
                self.placeholder!.backgroundColor = UIColor.clear
                self.placeholder!.textColor = self.placeholderColor
                self.placeholder!.alpha = 0
                self.placeholder!.tag = 999
                self.addSubview(self.placeholder!)
        }
            self.placeholder!.text = self.placeholderText
            self.placeholder!.sizeToFit()
            self.sendSubview(toBack: self.placeholder!)
        }
        if (self.text.characters.count == 0) && (self.placeholderText!.characters.count > 0) {
            self.viewWithTag(999)!.alpha = 1
        }
        super.draw(rect)
    }
}
