//
//  GradientButton.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 5/18/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
