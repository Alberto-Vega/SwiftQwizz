//
//  TableViewDataSource.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 7/21/17.
//  Copyright © 2017 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

public class TableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    var items: [T]
    var cellIdentifier: String
    
    init(items: [T], cellIdentifier: String) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell:UITableViewCell, indexPath: IndexPath) {
    }
}
