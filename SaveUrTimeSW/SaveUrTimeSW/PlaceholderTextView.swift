//
//  PlaceholderTextView.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceholderTextView: UITextView, UITextViewDelegate {

    @IBInspectable public var placeholderText: String?
    @IBInspectable public var placeholderColor: UIColor?
    
    private let PLACEHOLDER_TEXT_VIEW_TEXT_CHANGED_ANIMATION_DURATION : Double = 0.1
    private var placeholder: UILabel?
    
    /*deinit{
        NotificationCenter.default.removeObserver(self)
    }*/

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.placeholderText == nil {
            self.placeholderText = ""
        }
        if self.placeholderColor == nil {
            self.placeholderColor = UIColor.lightGray
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let placeholderTxt = self.placeholderText else {
            return
        }
        if placeholderTxt.characters.count == 0 {
            return
        }
        
        UIView.animate(withDuration: PLACEHOLDER_TEXT_VIEW_TEXT_CHANGED_ANIMATION_DURATION, animations:{() -> Void in
            //if self.viewWithTag(999) != nil{
            if let placeholdr = self.placeholder {
                if self.text.characters.count == 0{
                    //self.viewWithTag(999)!.alpha = 1
                    placeholdr.alpha = 1
                }
                else {
                    //self.viewWithTag(999)!.alpha = 0
                    placeholdr.alpha = 0
                }
            }
        })
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
        self.delegate = self
        //NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    /*func textChanged(notification: NSNotification?){
        if self.placeholderText!.characters.count == 0 {
            return
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
    }*/
    
    /*override public var text: String!{
        didSet{
            self.textChanged(notification: nil)
        }
    }*/

    override func draw(_ rect: CGRect) {
        guard let placeholderTxt = self.placeholderText else {
            super.draw(rect)
            return
        }
        if placeholderTxt.characters.count > 0 {
            if self.placeholder == nil {
                self.placeholder = UILabel.init(frame: CGRect(x: 8, y: 8, width: self.bounds.size.width - 16, height:0))
            }
            if let placeholdr = self.placeholder{
                placeholdr.lineBreakMode = NSLineBreakMode.byWordWrapping
                placeholdr.numberOfLines = 0
                placeholdr.font = self.font
                placeholdr.backgroundColor = UIColor.clear
                placeholdr.textColor = self.placeholderColor
                placeholdr.alpha = 0
                //self.placeholder!.tag = 999
                self.addSubview(placeholdr)
                placeholdr.text = self.placeholderText
                placeholdr.sizeToFit()
                self.sendSubview(toBack: placeholdr)
            }
        }
        if (self.text.characters.count == 0) && (placeholderTxt.characters.count > 0) {
            //self.viewWithTag(999)!.alpha = 1
            if let placeholdr = self.placeholder{
                placeholdr.alpha = 1
            }
        }
        super.draw(rect)
    }
}
