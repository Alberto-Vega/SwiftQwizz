//
//  Game.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 7/21/17.
//  Copyright © 2017 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class GameManager {
    
    var currentScore: Int
    var currentQuiz: Quiz?
    
    init?(currentChapter: ChapterCatalog, score: Int) {
        self.currentScore = score
        let questionLoader = QuestionLoader()
        let questionRandomizer = QuestionRandomizer()

        if let loadedQuestions = questionLoader.loadQuestionsFrom(plistFileName: currentChapter.rawValue),
           let randomizedQuestions = questionRandomizer.fetchQuestionsWithrandomIndexes(count: Constants.Quantity.Questions.rawValue, questionPool: loadedQuestions) {
            self.currentQuiz = Quiz(chapter: currentChapter.description, questions: randomizedQuestions)
        }
    }
    
    func clearQuestionsCache() {
        currentQuiz?.questions = [Question]()
    }
}
