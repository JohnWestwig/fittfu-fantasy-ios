//
//  LoadingOverlay.swift
//  FITTFU Fantasy
//
//  Created by John Westwig on 1/4/17.
//  Copyright © 2017 John Westwig. All rights reserved.
//

import UIKit
public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var numViews: Int = 0
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func add(view: UIView) {
        if (numViews == 0) {
            DispatchQueue.main.async {
                self.overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                self.overlayView.center = view.center
                self.overlayView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
                self.overlayView.clipsToBounds = true
                self.overlayView.layer.cornerRadius = 10
                
                self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
                self.activityIndicator.center = CGPoint(x: self.overlayView.bounds.width / 2, y: self.overlayView.bounds.height / 2)
                
                self.overlayView.addSubview(self.activityIndicator)
                view.addSubview(self.overlayView)
                
                self.activityIndicator.startAnimating()
            }
        }
        numViews += 1
    }
    
    public func remove() {
        numViews -= 1
        if (numViews == 0) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.overlayView.removeFromSuperview()
            }
        }
    }
}
