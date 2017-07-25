//
//  Chapter.swift
//  SwiftQwizz
//
//  Created by Alberto Vega Gonzalez on 3/10/16.
//  Copyright © 2016 Alberto Vega Gonzalez. All rights reserved.
//

import Foundation

enum ChapterCatalog: String, CustomStringConvertible {
    
    case TheBasics, StringsAndCharacters, Advanced
    
    var description: String {
        
        switch self {
        case .TheBasics:
            return "The Basics"
        case .StringsAndCharacters:
            return "Strings and Characters"
        case .Advanced:
            return "Advanced"
        }
    }
    
    func nextCase() -> ChapterCatalog? {
        switch self {
        case .TheBasics:
            return .StringsAndCharacters
        case .StringsAndCharacters:
            return .Advanced
        default:
            return nil
        }
    }
    
    static var allValues: [ChapterCatalog] {
        var array: [ChapterCatalog] = Array()
        var current: ChapterCatalog?
        
        current = ChapterCatalog.TheBasics
        
        while current != nil {
            array.append(current!)
            current = current?.nextCase()
        }
        return array
    }
}

