//
//  ResultsViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 8/5/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
  
  @IBOutlet weak var currentLevelLabel: UILabel!
  @IBOutlet weak var finalScoreLabel: UILabel!
  @IBOutlet weak var finalAccuracyLabel: UILabel!
  @IBOutlet weak var startLevelOneButton: UIButton!
  @IBOutlet weak var startLevelTwoButton: UIButton!
  
  @IBOutlet weak var startAgainButton: UIButton!
  var rightAnswersCounter: Int?
  var currentChapter: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setResultLabels()
    
    stylingButtons(startLevelOneButton)
    stylingButtons(startLevelTwoButton)

    
    if let currentLevel = currentChapter {
      currentLevelLabel.text = "Results for " + "\(currentLevel)"
      if currentLevel == "Level II" {
      startLevelOneButton.hidden = true
      startLevelTwoButton.hidden = true
      startAgainButton.hidden = false
      } else {
        startAgainButton.hidden = true
      }
  }
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
  
  
  func setResultLabels() {
    if let rightAnswers = rightAnswersCounter {
      print(" This is the unwrapped opcional value \(rightAnswers)")
      finalScoreLabel!.text = "\(rightAnswers)"
      finalAccuracyLabel!.text = "\((Double(rightAnswers)/10)*100)" + " %"
      print("\(finalAccuracyLabel!.text!)")
    }
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
