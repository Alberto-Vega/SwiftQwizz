//
//  ViewController.swift
//  SwiftExam
//
//  Created by Alberto Vega Gonzalez on 5/23/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class LevelOneViewController: UIViewController, UIPopoverPresentationControllerDelegate {
  
  @IBOutlet weak var currentChapterTextLabel: UILabel!
  @IBOutlet weak var questionNumberLabel: UILabel!
  @IBOutlet weak var scoreNumberLabel: UILabel!
  @IBOutlet var QuestionTextLabel: UILabel!
  @IBOutlet var buttonAnswer1: UIButton! {
    didSet {
      stylingButtons(buttonAnswer1)
    }
  }
  @IBOutlet var buttonAnswer2: UIButton! {
    didSet {
      stylingButtons(buttonAnswer2)
    }
  }
  @IBOutlet var buttonAnswer3: UIButton! {
    didSet {
      stylingButtons(buttonAnswer3)
    }
  }
  @IBOutlet weak var rightOrWrongTextLabel: UILabel!
  @IBOutlet weak var continueButton: UIButton!
  
//  var currentQuiz = Quiz()
  var rightAnswersCounter = 0
  var currentQuestionCounter = 0
  var questionPoolFromPlist = [Question] ()
  var currentQuizQuestions = [Question] ()
  var practiceMode:Bool?
  var currentChapter:String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
//    if let buttonOne = buttonAnswer1 {
//      stylingButtons(buttonOne)
//    }
//    if let buttonTwo = buttonAnswer2 { stylingButtons(buttonTwo)}
//    stylingButtons(buttonAnswer3)
    print("The current chapter is \(currentChapter)")
    currentChapterTextLabel.text = currentChapter
    loadQuestionsFromPlist()
    createQuizFromRandomQuestions()
    displayCurrentQuestion()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func loadQuestionsFromPlist() {
    print("Loading Questions from Plist")
    let questionsPath = NSBundle.mainBundle().pathForResource("QuestionsData", ofType: "plist")
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
  
  func stylingButtons(button: UIButton) {
    button.layer.shadowRadius = 8
    button.layer.shadowOffset = CGSize.zero
    button.layer.shadowColor = UIColor.blackColor().CGColor
    button.layer.shadowOpacity = 0.5
  }
  
  func createQuizFromRandomQuestions() {
    print("Creating current quiz from random Plist questions")
    var newIndex: Int?
    var previousIndexes = [Int]()
    
    while currentQuizQuestions.count < 10 {
      print("picking a random question index number...")
      
      let randomIndex = Int(arc4random_uniform(UInt32(questionPoolFromPlist.count)))
      newIndex = randomIndex
      print("the random index number picked is \(newIndex)")
      
//      findDuplicateIndex(indexToFind: newIndex!, fromIndexes: previousIndexes)
      
      if previousIndexes.indexOf(newIndex!) != nil {
        newIndex = nil
      } else {
        currentQuizQuestions.append(questionPoolFromPlist[newIndex!])
        previousIndexes.append(newIndex!)
      }
      print("The list of previous indexes is \(previousIndexes)")
      }
    }
  
//  func findDuplicateIndex(#indexToFind: Int, fromIndexes: [Int]) -> Bool {
//    for index in fromIndexes {
//      if index == indexToFind {
//        return true
//      }
//      }
//    return false
//  }

  func updateScore() {
    if currentQuizQuestions[currentQuestionCounter].userAnswer == currentQuizQuestions[currentQuestionCounter].rightAnswer {
      rightAnswersCounter += 1
      rightOrWrongTextLabel.text = "Yes!"
      if practiceMode == true {
      displayAnswerFeedback()
      stylingButtons(continueButton)
      continueButton.hidden = false
      }
    } else {
      rightOrWrongTextLabel.text = "Wrong"
      QuestionTextLabel.text = "Please try again."
      if practiceMode == true {
      stylingButtons(continueButton)
      continueButton.hidden = false
      }
    }
  }
  
  func displayCurrentQuestion() {
    if currentQuestionCounter < currentQuizQuestions.count {
      QuestionTextLabel.text = currentQuizQuestions[currentQuestionCounter].question
      buttonAnswer1.setTitle(currentQuizQuestions[currentQuestionCounter].answer1, forState: .Normal)
      buttonAnswer2.setTitle(currentQuizQuestions[currentQuestionCounter].answer2,
        forState: .Normal)
      buttonAnswer3.setTitle(currentQuizQuestions[currentQuestionCounter].answer3, forState: .Normal)
      
      questionNumberLabel.text = "\(currentQuestionCounter + 1)"
      scoreNumberLabel.text = "\(rightAnswersCounter)"
    }
  }
  
  func displayAnswerFeedback () {
      QuestionTextLabel.text = "\(currentQuizQuestions[currentQuestionCounter].rightAnswerMessage)"
    }
  
//  func resetQuiz() {
//    rightAnswersCounter = 0
//    currentQuestionCounter = 0
//    currentQuizQuestions = []
//    println("Reseting questions to start again")
//    createQuizFromRandomQuestions()
//    displayCurrentQuestion()
//  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if let identifier = segue.identifier {
      switch identifier {
      case "showResults":
        if let rvc: ResultsViewController =  segue.destinationViewController as? ResultsViewController {
              rvc.rightAnswersCounter = rightAnswersCounter
              rvc.currentChapter = currentChapter
        }
      case "Show Settings":
        if let svc = segue.destinationViewController as? SettingsTableViewController {
          if let ppc = svc.popoverPresentationController {
            ppc.delegate = self
            if let mode = practiceMode {
              svc.practiceMode = mode
            }
          }
        }
      default: break
      }
      

//    if segue.identifier == "showResults" {
//      var resultsVC: ResultsViewController =  segue.destinationViewController as! ResultsViewController
//      resultsVC.rightAnswersCounter = rightAnswersCounter
//      resultsVC.currentLevel = "Level I"
//    } else {
//      var levelTwoVC: LevelTwoViewController = segue.destinationViewController as! LevelTwoViewController
//      levelTwoVC.practiceMode = practiceMode
//    }
  }
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.None
  }
  
  @IBAction func answer(sender: UIButton) {
    
    switch sender {
    case buttonAnswer1:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 1
    case buttonAnswer2:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 2
    case buttonAnswer3:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 3
    default:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 0
    }
    updateScore()
    scoreNumberLabel.text = "\(rightAnswersCounter)"
    
    if practiceMode == true {
    buttonAnswer1.hidden = true
    buttonAnswer2.hidden = true
    buttonAnswer3.hidden = true
    QuestionTextLabel.hidden = true
    self.view.backgroundColor = UIColor.orangeColor()
    } else {
      currentQuestionCounter++
    }

    if (currentQuestionCounter) < 10 {
      displayCurrentQuestion()
    } else {
      self.performSegueWithIdentifier("showResults", sender:self)
    }
    print("the current index in the exam array is " + "\(currentQuestionCounter)")
      }
  
  @IBAction func continueButtonPressed(sender: AnyObject) {
    
    if currentQuizQuestions[currentQuestionCounter].userAnswer == currentQuizQuestions[currentQuestionCounter].rightAnswer {
    currentQuestionCounter++

    if (currentQuestionCounter) < 10 {
      displayCurrentQuestion()
    } else {
  self.performSegueWithIdentifier("showResults", sender:self)
    }
    }
    self.view.backgroundColor = UIColor.whiteColor()
    continueButton.hidden = true
    buttonAnswer1.hidden = false
    buttonAnswer2.hidden = false
    buttonAnswer3.hidden = false
    QuestionTextLabel.hidden = false
  }

  @IBAction func goBack(segue: UIStoryboardSegue) {
  print("Someone unwind back to me")
}
}

