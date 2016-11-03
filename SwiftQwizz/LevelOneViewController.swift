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
    @IBOutlet weak var continueButton: GradientButton!
    @IBOutlet var continueButtonXConstraint: NSLayoutConstraint!
    
    var currentChapter:Chapter?
    var questionController: QuestionController!
    var rightAnswersCounter = 0
    var currentQuestionCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionNumberLabel.isHidden = true
        self.QuestionTextLabel.isHidden = true
        self.rightOrWrongLabel.isHidden = true
        self.continueButtonXConstraint.constant = 0 - self.view.bounds.width * 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if let currentQuizChapter =  currentChapter {
            self.navigationItem.title = currentQuizChapter.name
            self.questionController = QuestionController()
            guard let questionPool = questionController.loadQuestionsFrom(plistFileName: currentQuizChapter.plistFileName) else { print("Failed to load questions from Plist")
                return
            }
            currentQuizChapter.questionPoolFromPlist = questionPool
            guard let randomQuestions = questionController.fetchQuestionsWithrandomIndexes(count: 10, questionPool: currentQuizChapter.questionPoolFromPlist) else { return }
            self.currentChapter?.questions = randomQuestions
            self.currentChapter?.questionPoolFromPlist = questionController.clearQuestionsCache()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayCurrentQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.currentChapter?.questions = questionController.clearQuestionsCache()
    }
    
    func stylingButtons(_ button: UIButton) {
        button.layer.cornerRadius = 9
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1
    }
    
    func updateScore() {
        if let currentChapter =  currentChapter {
            if currentChapter.questions[currentQuestionCounter].correctAnswer == true {
                rightAnswersCounter += 1
                displayAnswerFeedback(correct: true)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
                animateView(scoreNumberLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
            } else {
                displayAnswerFeedback(correct: false)
                scoreNumberLabel.text = "\(rightAnswersCounter)"
            }
        }
    }
    
    func animateRightAnswer(rightAnswer: Int?) {
        guard let rightAnswer = rightAnswer else { print("right answer is nil"); return }
        switch rightAnswer {
        case 1:
            buttonAnswer1.isEnabled = false
            animateView(buttonAnswer2, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer3, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
            
        case 2:
            buttonAnswer2.isEnabled = false
            animateView(buttonAnswer1, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer3, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
            
        case 3:
            buttonAnswer3.isEnabled = false
            animateView(buttonAnswer1, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
            animateView(buttonAnswer2, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
        default:
            break
        }
    }
    
    func displayCurrentQuestion() {
        if let currentChapter = currentChapter {
            if currentQuestionCounter < currentChapter.questions.count {
                
                QuestionTextLabel.text = currentChapter.questions[currentQuestionCounter].question
                animateView(QuestionTextLabel, show: true, animation: UIViewAnimationOptions.transitionFlipFromTop, delayTime: 0,completion: nil)
                buttonAnswer1.setTitle(currentChapter.questions[currentQuestionCounter].answer1, for: UIControlState())
                buttonAnswer2.setTitle(currentChapter.questions[currentQuestionCounter].answer2,
                                       for: UIControlState())
                buttonAnswer3.setTitle(currentChapter.questions[currentQuestionCounter].answer3, for: UIControlState())
                
                animateView(questionNumberLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.questionNumberLabel.text = "\(self.currentQuestionCounter + 1) of 10"
                Flurry.logEvent("Question Number: \(self.currentQuestionCounter + 1) seen")
            }
        }
    }
    
    func answerContainer(minimize: Bool) {
        
        if let answerContainerViewConstraints = answerContainerView.superview?.constraints {
            for constraint in answerContainerViewConstraints {
                if constraint.identifier == "AnswerContainerHeight" {
                    constraint.isActive = false
                    let newConstraint = NSLayoutConstraint(item: answerContainerView, attribute: .height, relatedBy: .equal, toItem: answerContainerView.superview!, attribute: .height, multiplier: minimize ? 0.085 : 0.25, constant: 0)
                    newConstraint.identifier = "AnswerContainerHeight"
                    newConstraint.isActive = true
                }
            }
        }
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func displayAnswerFeedback(correct: Bool) {
        animateView(rightOrWrongLabel, show: false, animation: .transitionCrossDissolve, delayTime: 0, completion: nil)
        delay(seconds: 0.4) {
            if correct {
                self.animateView(self.rightOrWrongLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.rightOrWrongLabel.text = "Nice job!"
            } else {
                self.animateView(self.rightOrWrongLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.rightOrWrongLabel.text = "I'm afraid the correct answer is: "
            }
        }
        animateConstraint(continueButtonXConstraint, constant: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showResults":
                if let rvc: ResultsViewController =  segue.destination as? ResultsViewController {
                    rvc.rightAnswersCounter = rightAnswersCounter
                    rvc.currentChapter = currentChapter
                }
            default: break
            }
        }
    }
    
    @IBAction func answer(_ sender: UIButton) {
        guard let currentChapter = currentChapter else { return print("currentChapter is nil")}
        switch sender {
        case buttonAnswer1:
            currentChapter.questions[currentQuestionCounter].userAnswer = 1
        case buttonAnswer2:
            currentChapter.questions[currentQuestionCounter].userAnswer = 2
        case buttonAnswer3:
            currentChapter.questions[currentQuestionCounter].userAnswer = 3
        default:
            currentChapter.questions[currentQuestionCounter].userAnswer = 0
        }
        animateRightAnswer(rightAnswer: currentChapter.questions[currentQuestionCounter].rightAnswer)
        self.updateScore()
        currentQuestionCounter += 1
        Flurry.logEvent("Question \(currentQuestionCounter) answered")
        Flurry.logEvent("Question Answered")
    }
    
    //MARK: -  Animations.
    
    func animateConstraint(_ constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant = constant
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 07.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateView(_ label: UIView, show: Bool, animation: UIViewAnimationOptions, delayTime: Double, completion: (() ->())?) {
        delay(seconds: delayTime) {
            if(!show) {
                UIView.transition(with: label, duration: 0.8, options: animation, animations: {
                    label.isHidden = true
                }, completion: nil)
            } else {
                UIView.transition(with: label, duration: 0.8, options: animation, animations: {
                    label.isHidden = false
                }, completion: nil)
            }
        }
        completion?()
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        animateConstraint(continueButtonXConstraint, constant: 0 - self.view.bounds.width * 0.65)
        
        animateView(buttonAnswer1, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
        animateView(buttonAnswer2, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
        animateView(buttonAnswer3, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
        buttonAnswer1.isEnabled = true
        buttonAnswer2.isEnabled = true
        buttonAnswer3.isEnabled = true
        animateView(QuestionTextLabel, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
        animateView(questionNumberLabel, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
        animateView(rightOrWrongLabel, show: false, animation: .transitionFlipFromBottom, delayTime: 0.0, completion: nil)
        
        delay(seconds: 0.4) {
            if (self.currentQuestionCounter) < 10 {
                self.displayCurrentQuestion()
            } else {
                self.performSegue(withIdentifier: "showResults", sender:self)
            }
        }
    }
}
