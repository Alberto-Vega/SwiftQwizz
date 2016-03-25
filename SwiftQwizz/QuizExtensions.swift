//
//  QuizExtensions.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 3/10/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

extension Quiz {
    
    mutating func createChapters() {
        let theBasics = Chapter(name: "The Basics", plistFileName: "QuestionsData")
        chapters.append(theBasics)
        let advanced = Chapter(name: "Advanced", plistFileName: "QuestionsDataAdvanced")
        chapters.append(advanced)
    }
}
