//
//  Question.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 3/10/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class Question {
    
    var question: String
    var answer1: String
    var answer2: String
    var answer3: String
    var rightAnswer: Int?
    var userAnswer: Int? {
        
        didSet {
            if let userAnswer = userAnswer {
                isCorrectAnswer = userAnswer == rightAnswer ? true : false
            }
        }
    }
    var isCorrectAnswer = false
    var rightAnswerMessage: String
    
    init(question: String, answer1: String, answer2: String, answer3: String, rightAnswer: Int, rightAnswerMessage: String) {
        
        self.question = question
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
        self.rightAnswer = rightAnswer
        self.rightAnswerMessage = rightAnswerMessage
    }
}
