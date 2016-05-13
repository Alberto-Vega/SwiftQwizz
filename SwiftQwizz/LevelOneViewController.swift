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
    @IBOutlet weak var answerContainerView: UIView!
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
//    @IBOutlet weak var rightOrWrongTextLabel: UILabel!
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
//        rightOrWrongTextLabel.hidden = true
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
//                animateAnswerButtons(scoreNumberLabel, show: false)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
                animateAnswerButtons(scoreNumberLabel, show: true)
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
            buttonAnswer1.enabled = false
            animateAnswerButtons(buttonAnswer2, show: false)
            animateAnswerButtons(buttonAnswer3, show: false)

        case 2:
            buttonAnswer2.enabled = false
            animateAnswerButtons(buttonAnswer1, show: false)
            animateAnswerButtons(buttonAnswer3, show: false)

        case 3:
            buttonAnswer3.enabled = false
            animateAnswerButtons(buttonAnswer1, show: false)
            animateAnswerButtons(buttonAnswer2, show: false)
        default:
            break
//            animateAnswerButtons(buttonAnswer1, show: false)
//            animateAnswerButtons(buttonAnswer2, show: false)
//            animateAnswerButtons(buttonAnswer3, show: false)

        }
    }
    
    func displayCurrentQuestion() {
        if let currentChapter = currentChapter {
            if currentQuestionCounter < currentChapter.Questions.count {

                QuestionTextLabel.text = currentChapter.Questions[currentQuestionCounter].question
                animateQuestionLabel(QuestionTextLabel, show: true, animation: UIViewAnimationOptions.TransitionFlipFromTop, delayTime: 0)
//                animateAnswerButtons(QuestionTextLabel, show: true)

                buttonAnswer1.setTitle(currentChapter.Questions[currentQuestionCounter].answer1, forState: .Normal)
                buttonAnswer2.setTitle(currentChapter.Questions[currentQuestionCounter].answer2,
                                       forState: .Normal)
                buttonAnswer3.setTitle(currentChapter.Questions[currentQuestionCounter].answer3, forState: .Normal)
                
//                animateAnswerButtons(questionNumberLabel, show: false)
//                animateAnswerButtons(questionNumberLabel, show: true)

                questionNumberLabel.text = "\(10 - currentQuestionCounter)"
//                animateAnswerButtons(scoreNumberLabel, show: true)
//                scoreNumberLabel.text = "\(rightAnswersCounter)"
                
            }
        }
    }
    
//    func answerContainer(minimize minimize: Bool) {
//        
//        if let answerContainerViewConstraints = answerContainerView.superview?.constraints {
//            for constraint in answerContainerViewConstraints {
//                if constraint.identifier == "AnswerContainerHeight" {
//                    constraint.active = false
//                    
//                    let newConstraint = NSLayoutConstraint(item: answerContainerView, attribute: .Height, relatedBy: .Equal, toItem: answerContainerView.superview!, attribute: .Height, multiplier: minimize ? 0.085 : 0.25, constant: 0)
//                    newConstraint.identifier = "AnswerContainerHeight"
//                    newConstraint.active = true
//                }
//            }
//        }
//        
//        UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseOut, animations: { 
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//    }
    
    func displayAnswerFeedback(correct correct: Bool) {
        
//        if let currentChapter = currentChapter {
////            QuestionTextLabel.text = "\(currentChapter.Questions[currentQuestionCounter].rightAnswerMessage)"
//        }
        animateQuestionLabel(QuestionTextLabel, show: false, animation: .TransitionCrossDissolve, delayTime: 0)
        delay(seconds: 0.4) { 
            if correct {
                self.animateAnswerButtons(self.QuestionTextLabel, show: true)
                self.QuestionTextLabel.text = "Nice Job this is the right answer:"
                
                
            } else {
                self.animateAnswerButtons(self.QuestionTextLabel, show: true)
                self.QuestionTextLabel.text = "I'm afraid the correct answer is: "
                
            }
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
//        answerContainer(minimize: true)
//        displayCurrentQuestion()
        self.updateScore()
        currentQuestionCounter += 1


        //    print("the current index in the exam array is " + "\(currentQuestionCounter)")
    }
    
//MARK: -  Animations.
    
    func animateConstraint(constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant = constant
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 07.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateAnswerButtons(label: UIView, show: Bool) {
        if !show {
        delay(seconds: 0) {
            UIView.transitionWithView(label, duration: 0.8, options: .TransitionFlipFromBottom, animations: {
                label.hidden = true
                }, completion: { (true) in
//                    self.answerContainerView.addSubview(label)

            })
        }
        } else {
            UIView.transitionWithView(label, duration: 0.6, options: .TransitionFlipFromTop, animations: {
                label.hidden = false
                
                }, completion: { (true) in
//                    label.removeFromSuperview()
            })
        }
    }
    
    func animateQuestionLabel(label: UILabel, show: Bool, animation: UIViewAnimationOptions, delayTime: Double) {
//        UIView.transitionWithView(label, duration: 0.8, options: .TransitionFlipFromBottom, animations: { 
//            label.hidden = show
//}) { (true) in
//        }
        delay(seconds: delayTime) {
            if(!show) {
                UIView.transitionWithView(label, duration: 0.8, options: animation, animations: {
                    label.hidden = true
                    }, completion: nil)
            } else {
                UIView.transitionWithView(label, duration: 0.8, options: animation, animations: {
                    label.hidden = false
                    }, completion: nil)
                
                
            }
        }

    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
//        guard let currentChapter = currentChapter else { return print("currentChapter is nil")}
//        answerContainer(minimize: false)
        animateConstraint(continueButtonXConstraint, constant: 0 - self.view.bounds.width * 0.65)
        
        animateAnswerButtons(buttonAnswer1, show: true)
        animateAnswerButtons(buttonAnswer2, show: true)
        animateAnswerButtons(buttonAnswer3, show: true)
        buttonAnswer1.enabled = true
        buttonAnswer2.enabled = true
        buttonAnswer3.enabled = true
        animateQuestionLabel(QuestionTextLabel, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0)
        
//        self.updateScore()
        delay(seconds: 0.4) {
            if (self.currentQuestionCounter) < 10 {
                self.displayCurrentQuestion()
            } else {
                self.performSegueWithIdentifier("showResults", sender:self)
            }
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

