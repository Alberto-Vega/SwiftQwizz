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
        if let currentChapter =  currentChapter {
            if currentChapter.Questions[currentQuestionCounter].correctAnswer {
                rightAnswersCounter += 1
                scoreNumberLabel.text = "\(rightAnswersCounter)"
                rightOrWrongTextLabel.text = "Yes!"
            } else {
                rightOrWrongTextLabel.text = "Wrong"
                QuestionTextLabel.text = "Please try again."
            }
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
    
    func displayAnswerFeedback () {
        
        if let currentChapter = currentChapter {
            QuestionTextLabel.text = "\(currentChapter.Questions[currentQuestionCounter].rightAnswerMessage)"
        }
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
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
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
        updateScore()
        
        currentQuestionCounter += 1
        
        if (currentQuestionCounter) < 10 {
            displayCurrentQuestion()
        } else {
            self.performSegueWithIdentifier("showResults", sender:self)
        }
        //    print("the current index in the exam array is " + "\(currentQuestionCounter)")
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        guard let currentChapter = currentChapter else { return print("currentChapter is nil")}
        
        if currentChapter.Questions[currentQuestionCounter].userAnswer == currentChapter.Questions[currentQuestionCounter].rightAnswer {
            currentQuestionCounter += 1
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

