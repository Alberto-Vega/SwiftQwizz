//
//  Chapter.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 3/10/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

struct Chapter {
    var name: String
    let plistFileName: String
    
    init(name: String, plistFileName: String) {
        self.name = name
        self.plistFileName = name
    }
}