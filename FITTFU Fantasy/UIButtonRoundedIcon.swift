//
//  UIButtonRoundedIcon.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/9/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonRoundedIcon: UIButton {
    
    @IBInspectable var myBackgroundColor: UIColor = UIColor.black {
        didSet(newBackgroundColor) {
            style()
        }
    }
    
    @IBInspectable var myImageColor: UIColor = UIColor.white {
        didSet(newImageColor) {
            style()
        }
    }
    
    @IBInspectable var myImageInsetWidth: CGFloat = 8.0 {
        didSet(newImageInsetWidth) {
            style()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            style()
        }
    }
    
    override func awakeFromNib() {
        style()
    }
    
    override func prepareForInterfaceBuilder() {
        style()
    }
    
    private func style() {
        imageView?.image!.withRenderingMode(.alwaysTemplate)
        if (titleLabel != nil) {
            titleLabel!.removeFromSuperview()
        }
        
        tintColor = isHighlighted ? myBackgroundColor : myImageColor
        backgroundColor = isHighlighted ? myImageColor : myBackgroundColor
        layer.cornerRadius = CGFloat(frame.height / 2)
        layer.borderColor = myBackgroundColor.cgColor
        layer.borderWidth = 5.0
        imageEdgeInsets = UIEdgeInsets(top: myImageInsetWidth, left: myImageInsetWidth, bottom: myImageInsetWidth, right: myImageInsetWidth)
        clipsToBounds = true
    }
    
}
