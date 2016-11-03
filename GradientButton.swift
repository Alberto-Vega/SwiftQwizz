//
//  GradientButton.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 5/18/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class GradientButton: UIButton {
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y: 1.0)
        
        gradientLayer.locations = [0.25, 0.5, 0.75]
        gradientLayer.colors = [UIColor.orange, UIColor.white, UIColor.orange].map { color in color.cgColor }
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
        gradientAnimation.duration = 3
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        mask = self.titleLabel
    }
}
