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
    var questions = [Question]()

    init(name: String, plistFileName: String) {
        self.name = name
        self.plistFileName = plistFileName
    }
}

extension Chapter {
    

    
    func createQuizFromRandomQuestions() {
        
        //    print("Creating current quiz from random questions on Plist")
        var previousIndexes = [Int]()
        while questions.count < 10 {
            //      print("picking a random question index number...")
            var randomIndex:Int?
            randomIndex = Int(arc4random_uniform(UInt32(questionPoolFromPlist.count)))
            //      print("the random index number picked is \(randomIndex)")
            if previousIndexes.indexOf(randomIndex!) != nil {
                randomIndex = nil
            } else {
                questions.append(questionPoolFromPlist[randomIndex!])
                previousIndexes.append(randomIndex!)
            }
            //      print("The list of previous indexes is \(previousIndexes)")
        }
    }
}