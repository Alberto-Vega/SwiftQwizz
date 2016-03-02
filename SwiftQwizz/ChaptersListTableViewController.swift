//
//  ChaptersListTableViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 10/7/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class ChaptersListTableViewController: UITableViewController {
  
  var currentQuiz = Quiz()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentQuiz.createChapters()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentQuiz.chapters.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChaptersListItem", forIndexPath: indexPath)
    let index = indexPath.row
    currentQuiz.currentChapter = self.currentQuiz.chapters[index]
    let chapterNameTextLabel = cell.viewWithTag(1) as! UILabel
    chapterNameTextLabel.text = currentQuiz.currentChapter?.name
    return cell
  }
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowLevelOneViewController" {
      if let LevelOneViewController = segue.destinationViewController as? LevelOneViewController {
        if let indexPath = self.tableView.indexPathForSelectedRow {
          let selectedRow = indexPath.row
          print("the table view tapped index is: \(selectedRow)")
          let chapter = currentQuiz.chapters[selectedRow]
          currentQuiz.currentChapter = chapter
          LevelOneViewController.currentQuiz = currentQuiz
        }
      }
    }
  }
}
