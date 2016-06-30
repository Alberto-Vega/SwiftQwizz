//
//  ChaptersListTableViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 10/7/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class ChaptersListTableViewController: UITableViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowLevelOneViewController
    }
    
    var currentQuiz = Quiz()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuiz.createChapters()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Chapters"
        self.navigationController?.navigationItem.backBarButtonItem?.action
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segueIdentifierForSegue(segue)
        
        switch segueIdentifier {
        case .ShowLevelOneViewController:
            
                if let LevelOneViewController = segue.destinationViewController as? LevelOneViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let selectedRow = indexPath.row
                    let selectedChapter = currentQuiz.chapters[selectedRow]
                    currentQuiz.currentChapter = selectedChapter
                    LevelOneViewController.currentChapter = currentQuiz.currentChapter
                    Flurry.logEvent("Chapter tapped \(selectedChapter.name)")
                }
            }
        }
    }
}


extension ChaptersListTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuiz.chapters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChaptersListItem", forIndexPath: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell:UITableViewCell, indexPath: NSIndexPath) {
        currentQuiz.currentChapter = self.currentQuiz.chapters[indexPath.row]
        let chapterNameTextLabel = cell.viewWithTag(1) as! UILabel
        chapterNameTextLabel.text = currentQuiz.currentChapter?.name
    }
}
