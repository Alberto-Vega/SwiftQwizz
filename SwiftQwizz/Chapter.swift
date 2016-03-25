//
//  Chapter.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 3/10/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class Chapter {
    var name: String
    let plistFileName: String
    var questionPoolFromPlist = [Question]()
    var Questions = [Question]()

    init(name: String, plistFileName: String) {
        self.name = name
        self.plistFileName = plistFileName
    }
}