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
    var currentChapter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setResultLabels()
        self.stylingButtons(startAgainButton)
        if let chapter = currentChapter {
            currentChapterLabel.text = "Chapter: \(chapter)"
            Flurry.logEvent("Finished Quizz")
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func setResultLabels() {
        if let rightAnswers = rightAnswersCounter {
            
            let accuracyPercentage = (Double(rightAnswers)/10)*100
            if accuracyPercentage < 60 {
                endOfQuizMessage!.text = "Good try!"
            } else if accuracyPercentage < 90 {
                endOfQuizMessage!.text = "Good Job!"
            } else {
                endOfQuizMessage!.text = "Impressive!"
            }
            finalScoreLabel?.text = "\(rightAnswers)"
            finalAccuracyLabel?.text = "\(accuracyPercentage)" + " %"
        }
    }
    
    func stylingButtons(_ button: UIButton) {
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func againButtonPressed(_ sender: Any) {
        if let navigationController = self.navigationController {
            for chapterListTableViewController in navigationController.viewControllers {
                if(chapterListTableViewController is ChaptersListTableViewController){
                    
                    navigationController.popToViewController(chapterListTableViewController, animated: true)
                }
            }
        }
        Flurry.logEvent("Again button tapped")
    }
}
