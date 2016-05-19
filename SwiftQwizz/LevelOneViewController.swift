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
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var scoreNumberLabel: UILabel!
    @IBOutlet var QuestionTextLabel: UILabel!
    @IBOutlet weak var rightOrWrongLabel: UILabel!
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
    @IBOutlet weak var continueButton: GradientButton!
    @IBOutlet var continueButtonXConstraint: NSLayoutConstraint!
    
    var currentChapter:Chapter?
    var rightAnswersCounter = 0
    var currentQuestionCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayCurrentQuestion()
        self.QuestionTextLabel.hidden = true
        self.rightOrWrongLabel.hidden = true
        self.continueButtonXConstraint.constant = 0 - self.view.bounds.width * 1.5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        if let currentQuizChapter =  currentChapter {
            self.navigationItem.title = currentQuizChapter.name
            currentQuizChapter.loadQuestionsFromPlistNamed(currentQuizChapter.plistFileName)
            currentQuizChapter.createQuizFromRandomQuestions()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stylingButtons(button: UIButton) {
        button.layer.cornerRadius = 9
        button.layer.borderColor = UIColor.orangeColor().CGColor
        button.layer.borderWidth = 1
    }
    
    func updateScore() {
        if let currentChapter =  currentChapter {
            if currentChapter.Questions[currentQuestionCounter].correctAnswer == true {
                rightAnswersCounter += 1
                displayAnswerFeedback(correct: true)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
                animateAnswerButtons(scoreNumberLabel, show: true)
            } else {
                displayAnswerFeedback(correct: false)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
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
        }
    }
    
    func displayCurrentQuestion() {
        if let currentChapter = currentChapter {
            if currentQuestionCounter < currentChapter.Questions.count {
                
                QuestionTextLabel.text = currentChapter.Questions[currentQuestionCounter].question
                animateQuestionLabel(QuestionTextLabel, show: true, animation: UIViewAnimationOptions.TransitionFlipFromTop, delayTime: 0)
                buttonAnswer1.setTitle(currentChapter.Questions[currentQuestionCounter].answer1, forState: .Normal)
                buttonAnswer2.setTitle(currentChapter.Questions[currentQuestionCounter].answer2,
                                       forState: .Normal)
                buttonAnswer3.setTitle(currentChapter.Questions[currentQuestionCounter].answer3, forState: .Normal)
                animateAnswerButtons(questionNumberLabel, show: true)
                
                questionNumberLabel.text = "\(currentQuestionCounter) of 10"
            }
        }
    }
    
    func answerContainer(minimize minimize: Bool) {
        
        if let answerContainerViewConstraints = answerContainerView.superview?.constraints {
            for constraint in answerContainerViewConstraints {
                if constraint.identifier == "AnswerContainerHeight" {
                    constraint.active = false
                    
                    let newConstraint = NSLayoutConstraint(item: answerContainerView, attribute: .Height, relatedBy: .Equal, toItem: answerContainerView.superview!, attribute: .Height, multiplier: minimize ? 0.085 : 0.25, constant: 0)
                    newConstraint.identifier = "AnswerContainerHeight"
                    newConstraint.active = true
                }
            }
        }
        
        UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func displayAnswerFeedback(correct correct: Bool) {
        animateQuestionLabel(rightOrWrongLabel, show: false, animation: .TransitionCrossDissolve, delayTime: 0)
        delay(seconds: 0.4) {
            if correct {
                self.animateAnswerButtons(self.rightOrWrongLabel, show: true)
                self.rightOrWrongLabel.text = "Nice Job this is the right answer:"
            } else {
                self.animateAnswerButtons(self.rightOrWrongLabel, show: true)
                self.rightOrWrongLabel.text = "I'm afraid the correct answer is: "
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
        self.updateScore()
        currentQuestionCounter += 1
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
                })
            }
        } else {
            UIView.transitionWithView(label, duration: 0.6, options: .TransitionFlipFromTop, animations: {
                label.hidden = false
                }, completion: { (true) in
            })
        }
    }
    
    func animateQuestionLabel(label: UILabel, show: Bool, animation: UIViewAnimationOptions, delayTime: Double) {
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
        animateConstraint(continueButtonXConstraint, constant: 0 - self.view.bounds.width * 0.65)
        
        animateAnswerButtons(buttonAnswer1, show: true)
        animateAnswerButtons(buttonAnswer2, show: true)
        animateAnswerButtons(buttonAnswer3, show: true)
        buttonAnswer1.enabled = true
        buttonAnswer2.enabled = true
        buttonAnswer3.enabled = true
        animateQuestionLabel(QuestionTextLabel, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0)
        animateAnswerButtons(rightOrWrongLabel, show: false)
        
        delay(seconds: 0.4) {
            if (self.currentQuestionCounter) < 10 {
                self.displayCurrentQuestion()
            } else {
                self.performSegueWithIdentifier("showResults", sender:self)
            }
        }
    }
}