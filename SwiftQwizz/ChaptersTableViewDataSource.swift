//
//  ChaptersTableViewDataSource.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 7/24/17.
//  Copyright © 2017 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

class ChaptersTableViewDataSource: TableViewDataSource<ChapterCatalog> {
    
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let currentChapter = self.items[indexPath.row]
        let chapterNameTextLabel = cell.viewWithTag(1) as! UILabel
        chapterNameTextLabel.text = currentChapter.description
    }
}
