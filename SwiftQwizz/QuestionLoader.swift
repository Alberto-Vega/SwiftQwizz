//
//  QuestionLoader.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 6/29/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class QuestionLoader {
    
    func loadQuestionsFrom(plistFileName: String) -> [Question]? {
        var questionPoolFromPlist: [Question]?
        let questionsPath = Bundle.main.path(forResource: plistFileName, ofType: "plist")
        if let questionObjects = NSArray(contentsOfFile: questionsPath!) as? [[String: AnyObject]] {
            questionPoolFromPlist = Array(repeating: Question(question: "", answer1: "", answer2: "", answer3: "", rightAnswer: 0, rightAnswerMessage: ""), count: questionObjects.count)
            for (index, question) in questionObjects.enumerated() {
                if let questionOne = question["question"] as? String, let answer1 = question["answer1"] as? String, let answer2 = question["answer2"] as? String, let answer3 = question["answer3"] as? String, let rightAnswer = question["rightAnswer"] as? Int, let rightAnswerMessage = question["rightAnswerMessage"] as? String {
                    let question = Question(question: questionOne, answer1: answer1, answer2: answer2, answer3: answer3, rightAnswer: rightAnswer, rightAnswerMessage: rightAnswerMessage)
                    questionPoolFromPlist?[index] = question
                }
            }
        }
        return questionPoolFromPlist ?? nil
    }
}


