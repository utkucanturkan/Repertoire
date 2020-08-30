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
    var model: Book?
    
    typealias Entity = Book
    
    // Expressions
    let name = Expression<String>("name")
    let userFK = Expression<Int64>("user_Id")
    
    // References
    let users = Table("users")
    let userId = Expression<Int64>("id")
    
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
        return table.insert(name <- model!.name, userFK <- model!.userId, status <- model!.status)
    }

    var updateExpression: Update {
        return table.filter(id == model!.id).update(name <- model!.name, status <- model!.status)
    }
 
    var deleteExpression: Delete {
        return table.filter(id == model!.id).delete()
    }
    
    
    func getAllBy(userId uid: Int64) throws -> [BookViewModel]? {
        var result: [BookViewModel]?
        
        guard let database = SQLiteDataAccessLayer.shared.db else { throw DataAccessError.Datastore_Connection_Error }
        
        let bookSongRepository = BookSongRepository()
        
        for row in try database.prepare(table.filter(userId == uid).filter(status == true).order(created))
        {
            let songCount = try? bookSongRepository.getSongCountBy(bookId: row[id])
            result?.append(BookViewModel(name: row[name], createdDate: row[created], songCount: songCount ?? 0))
        }
        
        return result
    }
}
