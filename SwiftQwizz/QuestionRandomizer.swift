//
//  QuestionRandomizer.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 7/24/17.
//  Copyright © 2017 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class QuestionRandomizer {
    
    func fetchQuestionsWithrandomIndexes(count: Int, questionPool: [Question])-> [Question]? {
        let randomIndexes = pickRandomIndexes(numberOfIndexes: count, fromPoolSize: questionPool.count)
        var questions: [Question] = Array(repeating: Question(question: "", answer1: "", answer2: "", answer3: "", rightAnswer: 0, rightAnswerMessage: ""), count: randomIndexes.count)
        for (index,number) in randomIndexes.enumerated() {
            questions[index] = questionPool[number]
        }
        return questions
    }
    
    private func pickRandomIndexes(numberOfIndexes: Int, fromPoolSize: Int) -> [Int] {
        var randomIndexes = [Int:Int](minimumCapacity: numberOfIndexes)
        while randomIndexes.count < 10 {
            let randomIndex = Int(arc4random_uniform(UInt32(fromPoolSize)))
            if (randomIndexes[randomIndex] == nil) {
                randomIndexes[randomIndex] = randomIndex
            }
        }
        return Array(randomIndexes.values)
    }
}
