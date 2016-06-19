//
//  ResultsViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 8/5/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class ResultsViewController:UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowChaptersListTableViewController
    }
    
    @IBOutlet weak var endOfQuizMessage: UILabel!
    @IBOutlet weak var currentChapterLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var finalAccuracyLabel: UILabel!
    @IBOutlet weak var startAgainButton: GradientButton!
    
    var rightAnswersCounter: Int?
    var currentChapter: Chapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setResultLabels()
        stylingButtons(startAgainButton)
        if let chapter = currentChapter {
            //    print("The current chapter in resultsvc: \(chapter)")
            currentChapterLabel.text = "Chapter: \(chapter.name)"
        Flurry.logEvent("Finished Quizz")
        }
    }
    
    func stylingButtons(button: UIButton) {
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOpacity = 0.5
    }
    
    func setResultLabels() {
        if let rightAnswers = rightAnswersCounter {
            //      print(" This is the unwrapped opcional value for right answers counter \(rightAnswers)")
            let accuracyPercentage = (Double(rightAnswers)/10)*100
            if accuracyPercentage < 60 {
                endOfQuizMessage!.text = "Good try!"
            } else if accuracyPercentage < 90 {
                endOfQuizMessage!.text = "Good Job!"
            } else {
                endOfQuizMessage!.text = "Impressive!"
            }
            finalScoreLabel!.text = "\(rightAnswers)"
            finalAccuracyLabel!.text = "\(accuracyPercentage)" + " %"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segueIdentifierForSegue(segue)
        switch segueIdentifier {
        case .ShowChaptersListTableViewController:
            
            Flurry.logEvent("Again button tapped")
        }
    }
}
