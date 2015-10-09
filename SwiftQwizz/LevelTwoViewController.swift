//
//  LevelTwoViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 8/4/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class LevelTwoViewController: UIViewController {
  
  
  @IBOutlet weak var questionNumberLabel: UILabel!
  @IBOutlet weak var scoreNumberLabel: UILabel!
  @IBOutlet var labelQuestion: UILabel!
  @IBOutlet weak var trueAnswerButton: UIButton!
  @IBOutlet weak var falseAnswerButton: UIButton!
  @IBOutlet weak var answerFeedbackView: UIView!
  @IBOutlet weak var rightOrWrongTextLabel: UILabel!
  
  @IBOutlet weak var rightAnswerRepetitionTextLabel: UILabel!
  
  @IBOutlet weak var continueButton: UIButton!
  
  var rightAnswersCounter = 0
  var wrongAnswersCounter = 0
  var currentQuestionCounter = 0
  var questionPoolFromPlist = [Question] ()
  var currentQuizQuestions = [Question] ()
  var practiceMode: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    stylingButtons(trueAnswerButton)
    stylingButtons(falseAnswerButton)
    loadQuestionsFromPlist()
    createQuizFromRandomQuestions()
    displayCurrentQuestion()
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
  
  func loadQuestionsFromPlist() {
    print("Loading questions from Plist")
    let questionsPath = NSBundle.mainBundle().pathForResource("QuestionsDataLevelTwo", ofType: "plist")
    if let questionObjects = NSArray(contentsOfFile: questionsPath!) as? [[String: AnyObject]] {
      for question in questionObjects {
        if let questionOne = question["question"] as? String, answer1 = question["answer1"] as? String, answer2 = question["answer2"] as? String, answer3 = question["answer3"] as?String, rightAnswer = question["rightAnswer"] as? Int, rightAnswerMessage = question["rightAnswerMessage"] as? String {
          let question = Question(question: questionOne, answer1: answer1, answer2: answer2, answer3: answer3, rightAnswer: rightAnswer, rightAnswerMessage: rightAnswerMessage)
          
          questionPoolFromPlist.append(question)
          print("Question pool has appended" + "\(questionPoolFromPlist.count)" + " questions from Plist")
        }
      }
    }
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
      
      if let index = previousIndexes.indexOf(newIndex!) {
        newIndex = nil
      } else {
        currentQuizQuestions.append(questionPoolFromPlist[newIndex!])
        previousIndexes.append(newIndex!)
      }
      print("The list of previous indexes is \(previousIndexes)")
    }
  }
  
  func displayCurrentQuestion() {
    if currentQuestionCounter < currentQuizQuestions.count {
      labelQuestion.text = currentQuizQuestions[currentQuestionCounter].question
      trueAnswerButton.setTitle(currentQuizQuestions[currentQuestionCounter].answer1, forState: .Normal)
      falseAnswerButton.setTitle((currentQuizQuestions[currentQuestionCounter].answer2), forState: .Normal)
      
      questionNumberLabel.text = "\(currentQuestionCounter + 1)"
      scoreNumberLabel.text = "\(rightAnswersCounter)"
    }
  }
  
  func updateScore() {
    if currentQuizQuestions[currentQuestionCounter].userAnswer == currentQuizQuestions[currentQuestionCounter].rightAnswer {
      rightAnswersCounter += 1
      rightOrWrongTextLabel.text = "Yes!"
      if practiceMode == true {
        displayAnswerFeedback()
        answerFeedbackView.hidden = false
        stylingButtons(continueButton)
        continueButton.hidden = false
      }
    } else {
      rightOrWrongTextLabel.text = "Wrong"
      rightAnswerRepetitionTextLabel.text = "Please try again."
      if practiceMode == true {
        answerFeedbackView.hidden = false
        stylingButtons(continueButton)
        continueButton.hidden = false
      }
    }
  }
  
  func displayQuizzResult() {
    if Float(rightAnswersCounter) > (Float(currentQuizQuestions.count)*0.70) {
      UIAlertView(title: "Score", message: "Congratulations your score is \(self.rightAnswersCounter) of " + "\(currentQuizQuestions.count)", delegate: self, cancelButtonTitle: "Start again").show()
      resetQuiz()
    } else {
      UIAlertView(title: "Score", message: "That was a valiant effort. Your score is \(rightAnswersCounter) of " + "\(currentQuizQuestions.count)", delegate: self, cancelButtonTitle: "Start again").show()
      resetQuiz()
    }
  }
  
  func resetQuiz() {
    rightAnswersCounter = 0
    wrongAnswersCounter = 0
    currentQuestionCounter = 0
    currentQuizQuestions = []
    print("Reseting questions to start again")
    createQuizFromRandomQuestions()
    displayCurrentQuestion()
  }
  
  
  func displayAnswerFeedback () {
    rightAnswerRepetitionTextLabel.text = "\(currentQuizQuestions[currentQuestionCounter].rightAnswerMessage)"
  }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showResultsLevelTwo" {
      let resultsVC: ResultsViewController =  segue.destinationViewController as! ResultsViewController
      resultsVC.rightAnswersCounter = rightAnswersCounter
      resultsVC.currentChapter = "Level II"

    }
  }
  
  @IBAction func answerButtonPressed(sender: UIButton) {
    switch sender {
    case trueAnswerButton:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 1
    default:
      currentQuizQuestions[currentQuestionCounter].userAnswer = 2
    }
    updateScore()
    scoreNumberLabel.text = "\(rightAnswersCounter)"
    
    if practiceMode == true {
    
    trueAnswerButton.hidden = true
    falseAnswerButton.hidden = true
    labelQuestion.hidden = true
    self.view.backgroundColor = UIColor.orangeColor()
    } else {
      currentQuestionCounter++
    }
    
    if (currentQuestionCounter) < 10 {
      displayCurrentQuestion()
    } else {
      self.performSegueWithIdentifier("showResultsLevelTwo", sender:self)
    }
    
    
    print("the current index in the exam array is " + "\(currentQuestionCounter)")
  }

  @IBAction func continueButtonPressed(sender: AnyObject) {
    
    if currentQuizQuestions[currentQuestionCounter].userAnswer == currentQuizQuestions[currentQuestionCounter].rightAnswer {
      currentQuestionCounter++
      
      if (currentQuestionCounter) < 10 {
        displayCurrentQuestion()
      } else {
self.performSegueWithIdentifier("showResultsLevelTwo", sender:self)
      }
    }
    self.view.backgroundColor = UIColor.whiteColor()
    answerFeedbackView.hidden = true
    continueButton.hidden = true
    falseAnswerButton.hidden = false
    trueAnswerButton.hidden = false
    labelQuestion.hidden = false
  }

  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
}
