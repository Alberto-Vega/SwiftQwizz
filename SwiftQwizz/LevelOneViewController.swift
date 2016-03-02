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
  
  var currentQuiz = Quiz()
  var rightAnswersCounter = 0
  var currentQuestionCounter = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    print("The LevelOneViewControler practice mode: \(currentQuiz.practiceMode)")
    currentChapterTextLabel.text = currentQuiz.currentChapter?.name
    currentQuiz.loadQuestionsFromPlistNamed("QuestionsData")
    currentQuiz.createQuizFromRandomQuestions()
    displayCurrentQuestion()
    rightOrWrongTextLabel.hidden = true
    continueButton.hidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func stylingButtons(button: UIButton) {
    button.layer.shadowRadius = 8
    button.layer.shadowOffset = CGSize.zero
    button.layer.shadowColor = UIColor.blackColor().CGColor
    button.layer.shadowOpacity = 0.5
  }
  
  func updateScore() {
    if currentQuiz.Questions[currentQuestionCounter].correctAnswer {
      rightAnswersCounter++
      scoreNumberLabel.text = "\(rightAnswersCounter)"
      rightOrWrongTextLabel.text = "Yes!"
        
//      if currentQuiz.practiceMode == true {
//        displayAnswerFeedback()
//        stylingButtons(continueButton)
//        continueButton.hidden = false
//      }
    } else {
      rightOrWrongTextLabel.text = "Wrong"
      QuestionTextLabel.text = "Please try again."
        
//      if currentQuiz.practiceMode == true {
//        stylingButtons(continueButton)
//        continueButton.hidden = false
//      }
    }
  }
  
  func displayCurrentQuestion() {
    if currentQuestionCounter < currentQuiz.Questions.count {
      QuestionTextLabel.text = currentQuiz.Questions[currentQuestionCounter].question
      buttonAnswer1.setTitle(currentQuiz.Questions[currentQuestionCounter].answer1, forState: .Normal)
      buttonAnswer2.setTitle(currentQuiz.Questions[currentQuestionCounter].answer2,
        forState: .Normal)
      buttonAnswer3.setTitle(currentQuiz.Questions[currentQuestionCounter].answer3, forState: .Normal)
      
      questionNumberLabel.text = "\(currentQuestionCounter + 1)"
      scoreNumberLabel.text = "\(rightAnswersCounter)"
    }
  }
  
  func displayAnswerFeedback () {
    QuestionTextLabel.text = "\(currentQuiz.Questions[currentQuestionCounter].rightAnswerMessage)"
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "showResults":
        if let rvc: ResultsViewController =  segue.destinationViewController as? ResultsViewController {
          rvc.rightAnswersCounter = rightAnswersCounter
          rvc.currentQuiz = currentQuiz
        }

      default: break
      }
    }
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.None
  }
  
  @IBAction func answer(sender: UIButton) {
    
    switch sender {
    case buttonAnswer1:
      currentQuiz.Questions[currentQuestionCounter].userAnswer = 1
    case buttonAnswer2:
      currentQuiz.Questions[currentQuestionCounter].userAnswer = 2
    case buttonAnswer3:
      currentQuiz.Questions[currentQuestionCounter].userAnswer = 3
    default:
      currentQuiz.Questions[currentQuestionCounter].userAnswer = 0
    }
    updateScore()

      currentQuestionCounter++
    
    if (currentQuestionCounter) < 10 {
      displayCurrentQuestion()
    } else {
      self.performSegueWithIdentifier("showResults", sender:self)
    }
//    print("the current index in the exam array is " + "\(currentQuestionCounter)")
  }
  
  @IBAction func continueButtonPressed(sender: AnyObject) {
    
    if currentQuiz.Questions[currentQuestionCounter].userAnswer == currentQuiz.Questions[currentQuestionCounter].rightAnswer {
      currentQuestionCounter++
      
      if (currentQuestionCounter) < 10 {
        displayCurrentQuestion()
      } else {
        self.performSegueWithIdentifier("showResults", sender:self)
      }
    }
    self.view.backgroundColor = UIColor.whiteColor()
    continueButton.hidden = true
    rightOrWrongTextLabel.hidden = true
    buttonAnswer1.hidden = false
    buttonAnswer2.hidden = false
    buttonAnswer3.hidden = false
    QuestionTextLabel.hidden = false
  }
}

