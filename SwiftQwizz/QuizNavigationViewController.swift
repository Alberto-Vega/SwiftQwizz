//
//  QuizNavigationViewController.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 10/11/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class QuizNavigationViewController: UINavigationController {
  
  var currentChapter:String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if segue.identifier == "ShowLevelOneViewController" {
      if let LevelOneViewController = segue.destinationViewController as? LevelOneViewController {
//        if let indexPath = self.tableView.indexPathForSelectedRow {
          //          let selectedRow = indexPath.row
//          let currentChapter = Chapters[indexPath.row]
          print( "Navigation controller current chapter is \(currentChapter)")
        
          LevelOneViewController.currentChapter = self.currentChapter
        }
//      }
    }
}



