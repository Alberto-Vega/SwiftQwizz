//
//  QuestionLoader.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 6/29/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

struct QuestionLoader {
func loadQuestionsFromPlistNamed(chapter: Chapter) {
    //    print("Loading Questions from Plist")
    let questionsPath = NSBundle.mainBundle().pathForResource(chapter.plistFileName, ofType: "plist")
    if let questionObjects = NSArray(contentsOfFile: questionsPath!) as? [[String: AnyObject]] {
        for question in questionObjects {
            if let questionOne = question["question"] as? String, answer1 = question["answer1"] as? String, answer2 = question["answer2"] as? String, answer3 = question["answer3"] as? String, rightAnswer = question["rightAnswer"] as? Int, rightAnswerMessage = question["rightAnswerMessage"] as? String {
                let question = Question(question: questionOne, answer1: answer1, answer2: answer2, answer3: answer3, rightAnswer: rightAnswer, rightAnswerMessage: rightAnswerMessage)
                chapter.questionPoolFromPlist.append(question)
                //          print("Question pool has appended  " + "\(questionPoolFromPlist.count)" + " questions from Plist")
            }
        }
    }
}
    
}