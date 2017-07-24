//
//  Quiz.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 10/8/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class Quiz {
    
    var chapter: String
    var questions: [Question]
    
    init(chapter: String, questions: [Question]) {
        self.chapter = chapter
        self.questions = questions
    }
}










