//
//  HomeViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 8/5/15.
//  Copyright (c) 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
  //  private let defaults = NSUserDefaults.standardUserDefaults()
  
  //  var practiceMode:Bool? {
  //    get { return defaults.objectForKey("Mode") as? Bool ?? false }
  //    set { defaults.setObject(newValue, forKey: "Mode") }
  //    }
  @IBOutlet weak var startButton: UIButton!
  var currentQuiz = Quiz()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.orangeColor()
    stylingButtons(startButton)
  }
  
  override func viewWillAppear(animated: Bool) {
    if let mode = currentQuiz.practiceMode {
      
      print("The initial state of practice Mode in HomeView: \(mode)")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if let identifier = segue.identifier {
      switch identifier {
        
      case "ShowChapterListTableView":
        
        if let tvc: ChaptersListTableViewController =  segue.destinationViewController as? ChaptersListTableViewController {
          tvc.currentQuiz = currentQuiz
          //          if let mode = currentQuiz.practiceMode {
          //          tvc.practiceMode = mode
          //          }
        }
        
      case "HomeShowSettings":
        
        if let svc = segue.destinationViewController as? SettingsTableViewController {
          if let ppc = svc.popoverPresentationController {
            ppc.delegate = self
            if let mode = currentQuiz.practiceMode {
              svc.practiceMode = mode
            }
          }
        }
      default: break
      }
    }
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.None
  }
  func stylingButtons(button: UIButton) {
    button.layer.shadowRadius = 8
    button.layer.shadowOffset = CGSize.zero
    button.layer.shadowColor = UIColor.blackColor().CGColor
    button.layer.shadowOpacity = 0.5
  }
}

