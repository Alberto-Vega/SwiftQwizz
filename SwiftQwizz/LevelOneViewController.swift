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
    @IBOutlet var continueButtonXConstraint: NSLayoutConstraint!
    
    
    var currentChapter:Chapter?
    var rightAnswersCounter = 0
    var currentQuestionCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //    print("The LevelOneViewControler practice mode: \(currentQuiz.practiceMode)")
        if let currentQuizChapter =  currentChapter {
            currentChapterTextLabel.text = currentQuizChapter.name
            currentQuizChapter.loadQuestionsFromPlistNamed(currentQuizChapter.plistFileName)
            //        for index in 1...currentQuiz.chapters.count {
            //        currentQuiz.loadQuestionsFromPlistNamed(currentQuiz.chapters[index].plistFileName)
            //        }
            
            currentQuizChapter.createQuizFromRandomQuestions()
        }
        displayCurrentQuestion()
        rightOrWrongTextLabel.hidden = true
        self.continueButtonXConstraint.constant = 0 - self.view.bounds.width * 0.65
//        continueButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stylingButtons(button: UIButton) {
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSizeMake(-2, 4)
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOpacity = 0.5
    }
    
    func updateScore() {
        if let currentChapter =  currentChapter {
            if currentChapter.Questions[currentQuestionCounter].correctAnswer == true {
                rightAnswersCounter += 1
                displayAnswerFeedback(correct: true)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
//                rightOrWrongTextLabel.text = "Yes!"
            } else {
                displayAnswerFeedback(correct: false)
                scoreNumberLabel.text = "\(rightAnswersCounter)"

//                rightOrWrongTextLabel.text = "Wrong"
//                QuestionTextLabel.text = "Please try again."
            }
        }
    }
    
    func animateRightAnswer(rightAnswer rightAnswer: Int?) {
        guard let rightAnswer = rightAnswer else { print("right answer is nil"); return }
        switch rightAnswer {
        case 1:
            animateAnswerButtons(buttonAnswer2, show: false)
            animateAnswerButtons(buttonAnswer3, show: false)

        case 2:
            animateAnswerButtons(buttonAnswer1, show: false)
            animateAnswerButtons(buttonAnswer3, show: false)

        case 3:
            animateAnswerButtons(buttonAnswer1, show: false)
            animateAnswerButtons(buttonAnswer2, show: false)
        default:
            animateAnswerButtons(buttonAnswer1, show: false)
            animateAnswerButtons(buttonAnswer2, show: false)
            animateAnswerButtons(buttonAnswer3, show: false)

        }
    }
    
    func displayCurrentQuestion() {
        if let currentChapter = currentChapter {
            if currentQuestionCounter < currentChapter.Questions.count {
                QuestionTextLabel.text = currentChapter.Questions[currentQuestionCounter].question
                buttonAnswer1.setTitle(currentChapter.Questions[currentQuestionCounter].answer1, forState: .Normal)
                buttonAnswer2.setTitle(currentChapter.Questions[currentQuestionCounter].answer2,
                                       forState: .Normal)
                buttonAnswer3.setTitle(currentChapter.Questions[currentQuestionCounter].answer3, forState: .Normal)
                
                questionNumberLabel.text = "\(currentQuestionCounter + 1)"
                scoreNumberLabel.text = "\(rightAnswersCounter)"
            }
        }
    }
    
    func displayAnswerFeedback(correct correct: Bool) {
        
//        if let currentChapter = currentChapter {
////            QuestionTextLabel.text = "\(currentChapter.Questions[currentQuestionCounter].rightAnswerMessage)"
//        }
        if correct {
            QuestionTextLabel.text = "Nice Job this is the right answer:"
        } else {
            QuestionTextLabel.text = "I'm afraid the correct answer is: "
        }
        animateConstraint(continueButtonXConstraint, constant: 0)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showResults":
                if let rvc: ResultsViewController =  segue.destinationViewController as? ResultsViewController {
                    rvc.rightAnswersCounter = rightAnswersCounter
                    rvc.currentChapter = currentChapter
                }
            default: break
            }
        }
    }
    
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.FormSheet
//    }
    
    @IBAction func answer(sender: UIButton) {
        guard let currentChapter = currentChapter else { return print("currentChapter is nil")}
        
        switch sender {
        case buttonAnswer1:
            currentChapter.Questions[currentQuestionCounter].userAnswer = 1
        case buttonAnswer2:
            currentChapter.Questions[currentQuestionCounter].userAnswer = 2
        case buttonAnswer3:
            currentChapter.Questions[currentQuestionCounter].userAnswer = 3
        default:
            currentChapter.Questions[currentQuestionCounter].userAnswer = 0
        }
        animateRightAnswer(rightAnswer: currentChapter.Questions[currentQuestionCounter].rightAnswer)
        displayCurrentQuestion()
        self.updateScore()
        currentQuestionCounter += 1


        //    print("the current index in the exam array is " + "\(currentQuestionCounter)")
    }
    
    func animateConstraint(constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant = constant
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .CurveEaseOut, animations: { 
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    func animateAnswerButtons(label: UIView, show: Bool) {
        if !show {
        delay(seconds: 0) {
            UIView.transitionWithView(label, duration: 0.8, options: .TransitionFlipFromBottom, animations: {
                label.hidden = true
                }, completion: { (true) in
            })
        }
        } else {
            UIView.transitionWithView(label, duration: 0.6, options: .TransitionFlipFromTop, animations: {
                label.hidden = false
                
                }, completion: { (true) in
            })
        }
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        guard let currentChapter = currentChapter else { return print("currentChapter is nil")}
        
        animateConstraint(continueButtonXConstraint, constant: 0 - self.view.bounds.width * 0.65)
        animateAnswerButtons(buttonAnswer1, show: true)
        animateAnswerButtons(buttonAnswer2, show: true)
        animateAnswerButtons(buttonAnswer3, show: true)
        
//        self.updateScore()
        if (currentQuestionCounter) < 10 {
            displayCurrentQuestion()
        } else {
            self.performSegueWithIdentifier("showResults", sender:self)
        }


//        if currentChapter.Questions[currentQuestionCounter].userAnswer == currentChapter.Questions[currentQuestionCounter].rightAnswer {
//            currentQuestionCounter += 1
//            if (currentQuestionCounter) < 10 {
//                displayCurrentQuestion()
//            } else {
//                self.performSegueWithIdentifier("showResults", sender:self)
//            }
//        }
//        self.view.backgroundColor = UIColor.whiteColor()
//        continueButton.hidden = true
//        rightOrWrongTextLabel.hidden = true
//        buttonAnswer1.hidden = false
//        buttonAnswer2.hidden = false
//        buttonAnswer3.hidden = false
//        QuestionTextLabel.hidden = false
    }
}

