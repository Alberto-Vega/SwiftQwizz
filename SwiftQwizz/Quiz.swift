//
//  Quiz.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 10/8/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class Quiz {
    var chapters = [Chapter]()
    var currentChapter: Chapter?
    var bestScore:Int?
    var defaults = UserDefaults.standard
}

extension Quiz {
    func createChapters() {
        let theBasics = Chapter(name: "The Basics", plistFileName: "QuestionsData")
        chapters.append(theBasics)
        let strings = Chapter(name: "Strings and Characters", plistFileName: "StringsAndCharsQuestions")
        chapters.append(strings)
        let advanced = Chapter(name: "Advanced", plistFileName: "QuestionsDataAdvanced")
        chapters.append(advanced)
    }
    
//    func addChapter(name: String, plistFileName: String) {
//        let newChapter = Chapter(name: name, plistFileName: plistFileName)
//        self.chapters.append(newChapter)
//    }
}








