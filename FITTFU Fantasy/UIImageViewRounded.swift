//
//  UIImageViewRounded.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/4/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewRounded: UIImageView {

    override func awakeFromNib() {
        style()
    }
    
    override func prepareForInterfaceBuilder() {
        style()
    }
    
    private func style() {
        layer.cornerRadius = frame.size.height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor(red:0.25, green:0.49, blue:0.76, alpha:1.0).cgColor
        clipsToBounds = true
    }

}
