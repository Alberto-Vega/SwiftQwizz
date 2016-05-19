//
//  GradientButton.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 5/18/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit
import QuartzCore

//@IBDesignable
class GradientButton: UIButton {
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.whiteColor().CGColor
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y: 1.0)
        
        gradientLayer.locations = [0.25, 0.5, 0.75]
        gradientLayer.colors = [UIColor.orangeColor(), UIColor.whiteColor(), UIColor.orangeColor()].map { color in color.CGColor }
        return gradientLayer
    }()

    override func didMoveToWindow() {
        super.didMoveToWindow()
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y , width: 3 * bounds.size.width, height: bounds.size.height)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 2.5
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.addAnimation(gradientAnimation, forKey: nil)
        
        maskView = self.titleLabel
    }
}
