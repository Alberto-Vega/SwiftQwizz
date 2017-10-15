//
//  ViewController.swift
//  SwiftExam
//
//  Created by Alberto Vega Gonzalez on 5/23/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: UIViewController, UIPopoverPresentationControllerDelegate, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowResultsViewController
    }
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var scoreNumberLabel: UILabel!
    @IBOutlet var QuestionTextLabel: UILabel!
    @IBOutlet weak var rightOrWrongLabel: UILabel!
    @IBOutlet weak var answerContainerView: UIView!
    @IBOutlet var buttonAnswer1: UIButton! {
        didSet {
            setAppearanceFor(buttonAnswer1)
        }
    }
    @IBOutlet var buttonAnswer2: UIButton! {
        didSet {
            setAppearanceFor(buttonAnswer2)
        }
    }
    @IBOutlet var buttonAnswer3: UIButton! {
        didSet {
            setAppearanceFor(buttonAnswer3)
        }
    }
    @IBOutlet weak var continueButton: GradientButton!
    @IBOutlet var continueButtonXConstraint: NSLayoutConstraint!
    
    var game: GameManager? = nil
    var rightAnswersCounter = 0
    var currentQuestionCounter = 0

    //: MARK - Application Life cycle.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViews()
        self.setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayCurrentQuestion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.game?.clearQuestionsCache()
    }
    
    //MARK: -  Navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segueIdentifierForSegue(segue)
        
        switch segueIdentifier {
        case .ShowResultsViewController:
            if let resultsViewController: ResultsViewController =  segue.destination as? ResultsViewController {
                resultsViewController.rightAnswersCounter = rightAnswersCounter
                if let game = self.game,
                   let currentQuiz = game.currentQuiz {
                    resultsViewController.currentChapter = currentQuiz.chapter
                }
            }
        }
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
    
    //MARK: -  IBActions.
    @IBAction func answer(_ sender: UIButton) {
        guard let currentQuiz = game?.currentQuiz else { return print("currentChapter is nil")}
        let currentQuestion = currentQuiz.questions[currentQuestionCounter]
        
        self.setUserAnswer(sender: sender, question: currentQuestion)
        presentRightAnswer(rightAnswer: currentQuestion.rightAnswer)
        self.updateScore()
        currentQuestionCounter += 1
        Flurry.logEvent("Question \(currentQuestionCounter) answered")
        Flurry.logEvent("Question Answered")
    }
    
    func setUserAnswer(sender: UIButton, question: Question) {
        switch sender {
        case buttonAnswer1:
            question.userAnswer = 1
        case buttonAnswer2:
            question.userAnswer = 2
        case buttonAnswer3:
            question.userAnswer = 3
        default:
            question.userAnswer = 0
        }
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
                self.performSegue(withIdentifier: SegueIdentifier.ShowResultsViewController.rawValue, sender:self)
            }
        }
    }
    //: MARK - Helper Functions.
    func setAppearanceFor(_ button: UIButton) {
        button.layer.cornerRadius = 9
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1
    }
    
    func setupViews()  {
        self.questionNumberLabel.isHidden = true
        self.QuestionTextLabel.isHidden = true
        self.rightOrWrongLabel.isHidden = true
        self.continueButtonXConstraint.constant = 0 - self.view.bounds.width * 2
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        if let currentQuizChapter = game?.currentQuiz?.chapter {
            self.navigationItem.title = currentQuizChapter
        }
    }
    
    func displayCurrentQuestion() {
        
        if let gameManager = self.game,
           let currentQuiz = gameManager.currentQuiz {
            if currentQuestionCounter < currentQuiz.questions.count {
                QuestionTextLabel.text = currentQuiz.questions[currentQuestionCounter].question
                animateView(QuestionTextLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
                buttonAnswer1.setTitle(currentQuiz.questions[currentQuestionCounter].answer1, for: UIControlState())
                buttonAnswer2.setTitle(currentQuiz.questions[currentQuestionCounter].answer2,
                                       for: UIControlState())
                buttonAnswer3.setTitle(currentQuiz.questions[currentQuestionCounter].answer3, for: UIControlState())
                if currentQuiz.questions[currentQuestionCounter].answer3 == "" {
                    buttonAnswer3.isHidden = true
                } else {
                    buttonAnswer3.isHidden = false
                }
                
                animateView(questionNumberLabel, show: true, animation: .transitionFlipFromTop, delayTime: 0.0, completion: nil)
                self.questionNumberLabel.text = "\(self.currentQuestionCounter + 1) of 10"
                
                Flurry.logEvent("Question Number: \(self.currentQuestionCounter + 1) seen")
            }
        }
    }
    
    func updateScore() {
        if let currentQuiz = self.game?.currentQuiz {
            let currentAnswer = currentQuiz.questions[currentQuestionCounter]
            
            if currentAnswer.isCorrectAnswer {
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
    
    func presentRightAnswer(rightAnswer: Int?) {
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
}
