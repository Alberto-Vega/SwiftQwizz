//
//  ChaptersListTableViewController.swift
//  SwiftQuiz
//
//  Created by Alberto Vega Gonzalez on 10/7/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class ChaptersListTableViewController: UITableViewController, SegueHandlerType {
    
    var dataSource:ChaptersTableViewDataSource?
    
    enum SegueIdentifier: String {
        case ShowQuizViewController
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarApperance()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segueIdentifierForSegue(segue)
        
        switch segueIdentifier {
            
        case .ShowQuizViewController:
            self.passSelectedChapterToQuizViewController(segue: segue)
        }
    }
    
    // MARK: - Helper Functions
    func setupTableViewDataSource() {
        self.dataSource = ChaptersTableViewDataSource(items: ChapterCatalog.allValues, cellIdentifier: Constants.CellIdentifiers.ChaptersListItem.rawValue)
        self.tableView.dataSource = self.dataSource
    }
    
    func setupNavigationBarApperance() -> Void {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Chapters"
    }
    
    func passSelectedChapterToQuizViewController(segue: UIStoryboardSegue) {
        if let levelOneViewController = segue.destination as? QuizViewController,
           let indexPath = self.tableView.indexPathForSelectedRow {
           let selectedRow = indexPath.row
            if let selectedChapter = dataSource?.items[selectedRow],
               let gameManagerForQuizChapter = GameManager(currentChapter: selectedChapter, score: 0) {
                levelOneViewController.game = gameManagerForQuizChapter
                Flurry.logEvent("User started chapter \(selectedChapter.rawValue)")
            }
        }
    }
}

