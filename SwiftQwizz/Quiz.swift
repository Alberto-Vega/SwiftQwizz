//
//  Quiz.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 10/8/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

struct Quiz {
  var chapters = [Chapter]()
  var currentChapter: Chapter?
  var questionPoolFromPlist = [Question]()
  var Questions = [Question]()
  var bestScore:Int?
  var defaults = NSUserDefaults.standardUserDefaults()
  var practiceMode:Bool? {
    get { return defaults.objectForKey("Mode") as? Bool ?? false }
    set { defaults.setObject(newValue, forKey: "Mode") }
  }
}
extension Quiz {
  
  mutating func createChapters() {
    
    let theBasics = Chapter(name: "The Basics", plistFileName: "QuestionsData.plist")
    let basicOperators = Chapter(name: "Basic Operators", plistFileName: "QuestionsData.plist")
    chapters = [theBasics, basicOperators]
    //    chapters = ["The Basics", "Basic Operators", "Strings and Characters", "Collection Types", "Control Flow", "Functions", "Closures", "Enumerations", "Classes and Structures", "Properties", "Methods", "Subscripts", "Inheritance", "Initialization", "Deinitialization", "Automatic Reference Counting", "Optional Chaining", "Error Handling", "Type Casting", "Nested Types", "Extensions", "Protocols", "Generics", "Access Control", "Advanced Operators"]
  }
  
  mutating func loadQuestionsFromPlistNamed(plistName: String) {
    print("Loading Questions from Plist")
    let questionsPath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
    if let questionObjects = NSArray(contentsOfFile: questionsPath!) as? [[String: AnyObject]] {
      for question in questionObjects {
        if let questionOne = question["question"] as? String, answer1 = question["answer1"] as? String, answer2 = question["answer2"] as? String, answer3 = question["answer3"] as? String, rightAnswer = question["rightAnswer"] as? Int, rightAnswerMessage = question["rightAnswerMessage"] as? String {
          let question = Question(question: questionOne, answer1: answer1, answer2: answer2, answer3: answer3, rightAnswer: rightAnswer, rightAnswerMessage: rightAnswerMessage)
          questionPoolFromPlist.append(question)
          print("Question pool has appended  " + "\(questionPoolFromPlist.count)" + " questions from Plist")
        }
      }
    }
        }
  
  
  mutating func createQuizFromRandomQuestions() {
    
    print("Creating current quiz from random questions on Plist")
    var previousIndexes = [Int]()
    while Questions.count < 10 {
      print("picking a random question index number...")
      var randomIndex:Int?
      randomIndex = Int(arc4random_uniform(UInt32(questionPoolFromPlist.count)))
      print("the random index number picked is \(randomIndex)")
      
      if previousIndexes.indexOf(randomIndex!) != nil {
        randomIndex = nil
      } else {
        Questions.append(questionPoolFromPlist[randomIndex!])
        previousIndexes.append(randomIndex!)
      }
      print("The list of previous indexes is \(previousIndexes)")
    }
  }
}


struct Question {
  var question: String
  var answer1: String
  var answer2: String
  var answer3: String
  var rightAnswer: Int?
  var userAnswer: Int? {
    willSet {
      print("The new value of userAnswer is:\(newValue)")
    }
    didSet {
      if let answer = userAnswer {
        correctAnswer = answer == rightAnswer ? true : false
        print("User answer is correct: \(correctAnswer)")
      }
    }
  }
  var correctAnswer = false
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

struct Chapter {
  var name: String
  let plistFileName: String
  
  init(name: String, plistFileName: String) {
    self.name = name
    self.plistFileName = name
  }
}







