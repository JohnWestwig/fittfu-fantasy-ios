//
//  UIButtonPrimary.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/4/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit

struct Properties {
    let backgroundColor: UIColor
}

struct Themes {
    static let primary = Properties(backgroundColor: UIColor(red:0.25, green:0.49, blue:0.76, alpha:1.0))
    static let success = Properties(backgroundColor: UIColor(red:0.00, green:0.50, blue:0.25, alpha:1.0))
    static let danger = Properties(backgroundColor: UIColor(red:0.84, green:0.14, blue:0.14, alpha:1.0))
}

@IBDesignable
class UIButtonPrimary: UIButton {
    var myCurrentTheme: Properties = Themes.primary {
        didSet {
            style()
        }
    }
    
    @IBInspectable var myCurrentThemeAdapter: String = "Primary" {
        didSet{
            switch (myCurrentThemeAdapter) {
            case "Primary":
                myCurrentTheme = Themes.primary
                break
            case "Success":
                myCurrentTheme = Themes.success
                break
            case "Danger":
                myCurrentTheme = Themes.danger
                break
            default:
                myCurrentTheme = Themes.primary
            }
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
        layer.cornerRadius = 10
        contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        backgroundColor = myCurrentTheme.backgroundColor
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.brown, for: .highlighted)
        titleLabel!.font = UIFont(name: "Trebuchet MS", size: 20)
    }
}
