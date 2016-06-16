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
        self.questionNumberLabel.hidden = true
        self.QuestionTextLabel.hidden = true
        self.rightOrWrongLabel.hidden = true
        self.continueButtonXConstraint.constant = 0 - self.view.bounds.width * 2
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        displayCurrentQuestion()
        
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
                animateView(scoreNumberLabel, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
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
            animateView(buttonAnswer2, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer3, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
            
        case 2:
            buttonAnswer2.enabled = false
            animateView(buttonAnswer1, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer3, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
            
        case 3:
            buttonAnswer3.enabled = false
            animateView(buttonAnswer1, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer2, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
        default:
            break
        }
    }
    
    func displayCurrentQuestion() {
        if let currentChapter = currentChapter {
            if currentQuestionCounter < currentChapter.Questions.count {
                
                QuestionTextLabel.text = currentChapter.Questions[currentQuestionCounter].question
                animateView(QuestionTextLabel, show: true, animation: UIViewAnimationOptions.TransitionFlipFromTop, delayTime: 0,completion: nil)
                buttonAnswer1.setTitle(currentChapter.Questions[currentQuestionCounter].answer1, forState: .Normal)
                buttonAnswer2.setTitle(currentChapter.Questions[currentQuestionCounter].answer2,
                                       forState: .Normal)
                buttonAnswer3.setTitle(currentChapter.Questions[currentQuestionCounter].answer3, forState: .Normal)
                
                animateView(questionNumberLabel, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.questionNumberLabel.text = "\(self.currentQuestionCounter + 1) of 10"
                Flurry.logEvent("Question Number: \(self.currentQuestionCounter + 1) seen")
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
        animateView(rightOrWrongLabel, show: false, animation: .TransitionCrossDissolve, delayTime: 0, completion: nil)
        delay(seconds: 0.4) {
            if correct {
                self.animateView(self.rightOrWrongLabel, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.rightOrWrongLabel.text = "Nice job!"
            } else {
                self.animateView(self.rightOrWrongLabel, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
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
        Flurry.logEvent("Questions answered + \(currentQuestionCounter)")
        Flurry.logEvent("Question Answered")
    }
    
    //MARK: -  Animations.
    
    func animateConstraint(constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant = constant
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 07.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateView(label: UIView, show: Bool, animation: UIViewAnimationOptions, delayTime: Double, completion: (() ->())?) {
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
        completion?()
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        animateConstraint(continueButtonXConstraint, constant: 0 - self.view.bounds.width * 0.65)
        
        animateView(buttonAnswer1, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
        animateView(buttonAnswer2, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
        animateView(buttonAnswer3, show: true, animation: .TransitionFlipFromTop, delayTime: 0.0, completion: nil)
        buttonAnswer1.enabled = true
        buttonAnswer2.enabled = true
        buttonAnswer3.enabled = true
        animateView(QuestionTextLabel, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
        animateView(questionNumberLabel, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
        animateView(rightOrWrongLabel, show: false, animation: .TransitionFlipFromBottom, delayTime: 0.0, completion: nil)
        
        delay(seconds: 0.4) {
            if (self.currentQuestionCounter) < 10 {
                self.displayCurrentQuestion()
            } else {
                self.performSegueWithIdentifier("showResults", sender:self)
            }
        }
    }
}