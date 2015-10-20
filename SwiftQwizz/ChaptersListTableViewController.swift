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
  
  
  
  
//    var practiceMode:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
      currentQuiz.createChapters()
//      let message = "The Class instance was not received in table view"
      if let quizMode = currentQuiz.practiceMode {
//      let messageToPrint = ("\(quizInstance.practiceMode) ?? \(message)")
//        print("\(message) \(messageToPrint)")
        print("Practice mode in tvc is \(quizMode)")
      }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "ShowLevelOneViewController" {
        if let LevelOneViewController = segue.destinationViewController as? LevelOneViewController {
        if let indexPath = self.tableView.indexPathForSelectedRow {
          let selectedRow = indexPath.row
          print("the table view tapped index is: \(selectedRow)")

          let chapter = currentQuiz.chapters[selectedRow]
          
          currentQuiz.currentChapter = chapter
//          print(currentChapter)
//          LevelOneViewController.currentQuiz = currentQuiz!
          
      
            LevelOneViewController.currentQuiz = currentQuiz
          }
        }
      }
    }
}
