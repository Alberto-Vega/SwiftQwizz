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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Chapters"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segueIdentifierForSegue(segue)
        
        switch segueIdentifier {
        case .ShowLevelOneViewController:
            
                if let LevelOneViewController = segue.destination as? LevelOneViewController {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuiz.chapters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChaptersListItem", for: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell:UITableViewCell, indexPath: IndexPath) {
        currentQuiz.currentChapter = self.currentQuiz.chapters[indexPath.row]
        let chapterNameTextLabel = cell.viewWithTag(1) as! UILabel
        chapterNameTextLabel.text = currentQuiz.currentChapter?.name
    }
}
