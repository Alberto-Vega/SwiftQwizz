//
//  Quiz.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 10/8/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

struct Quiz {
    var chapters = [Chapter]()
    var currentChapter: Chapter?
    var bestScore:Int?
    var defaults = NSUserDefaults.standardUserDefaults()
}








