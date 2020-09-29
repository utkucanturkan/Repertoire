//
//  SongGroupModelType.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 29.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

protocol SongGroupModelType {
    var name: String { get }
    var searchBarPlaceholder: String { get }
    var type: SongGroupType { get }
    var alertTitle: String { get }
    var alertMessage: String { get }
    var alertTextfieldPlaceholder: String { get }
    var emptyTableview: (title: String, message: String) { get }
}

struct BookSongGroup: SongGroupModelType {
    var emptyTableview: (title: String, message: String) {
        return ("You have not any song book", "A new book can be added by + button on the left corner")
    }
    
    
    var alertTextfieldPlaceholder: String { return "Input a new book name" }
    
    var alertTitle: String { return "New Book" }
    
    var alertMessage: String { return "Set a name of the new book" }
    
    var type: SongGroupType { return .book }
    
    var searchBarPlaceholder: String { return "Search a book" }
    
    var name: String { return "Book" }
    
    
}

struct CategorySongGroup: SongGroupModelType {
    var emptyTableview: (title: String, message: String) {
        return ("You have not any category", "A new category can be added by + button on the left corner")
    }
    
    var alertTextfieldPlaceholder: String { return "Input a new category name" }
    
    var alertTitle: String { return "New Category" }
    
    var alertMessage: String { return "Set a name of the new category" }
    
    var type: SongGroupType { return .category }
    
    var searchBarPlaceholder: String { return "Search a category" }
    
    var name: String { return "Category" }
}
