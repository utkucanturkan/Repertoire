//
//  BookRepository.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct BookRepository: RepositoryProtocol {
    var tableName: String {
        return "books"
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name, unique: true)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
            t.column(userFK)
            t.foreignKey(userFK, references: users, userId, delete: .cascade)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(name <- model.name)
    }
    
    
    var model: Book
    
    init(book: Book) {
        model = book
    }
    
    // Expressions
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let userFK = Expression<Int64>("user_Id")
    let created = Expression<Date>("created")
    let updated = Expression<Date?>("updated")
    let status = Expression<Bool>("status")
    
    // References
    let users = Table("users")
    let userId = Expression<Int64>("id")
            
    func delete(item: Book) throws {
        
    }
    
    func findAll() throws -> [Book]? {
        return nil
    }
    
    typealias Entity = Book
}
