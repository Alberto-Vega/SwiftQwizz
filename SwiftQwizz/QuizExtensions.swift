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
//        let advanced = Chapter(name: "Advanced", plistFileName: "QuestionsDataAdvanced.plist")
//        chapters.append(advanced)
    }
    
    mutating func loadQuestionsFromPlistNamed(plistName: String) {
        //    print("Loading Questions from Plist")
        let questionsPath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        if let questionObjects = NSArray(contentsOfFile: questionsPath!) as? [[String: AnyObject]] {
            for question in questionObjects {
                if let questionOne = question["question"] as? String, answer1 = question["answer1"] as? String, answer2 = question["answer2"] as? String, answer3 = question["answer3"] as? String, rightAnswer = question["rightAnswer"] as? Int, rightAnswerMessage = question["rightAnswerMessage"] as? String {
                    let question = Question(question: questionOne, answer1: answer1, answer2: answer2, answer3: answer3, rightAnswer: rightAnswer, rightAnswerMessage: rightAnswerMessage)
                    questionPoolFromPlist.append(question)
                    //          print("Question pool has appended  " + "\(questionPoolFromPlist.count)" + " questions from Plist")
                }
            }
        }
    }
    
    mutating func createQuizFromRandomQuestions() {
        
        //    print("Creating current quiz from random questions on Plist")
        var previousIndexes = [Int]()
        while Questions.count < 10 {
            //      print("picking a random question index number...")
            var randomIndex:Int?
            randomIndex = Int(arc4random_uniform(UInt32(questionPoolFromPlist.count)))
            //      print("the random index number picked is \(randomIndex)")
            if previousIndexes.indexOf(randomIndex!) != nil {
                randomIndex = nil
            } else {
                Questions.append(questionPoolFromPlist[randomIndex!])
                previousIndexes.append(randomIndex!)
            }
            //      print("The list of previous indexes is \(previousIndexes)")
        }
    }
}
