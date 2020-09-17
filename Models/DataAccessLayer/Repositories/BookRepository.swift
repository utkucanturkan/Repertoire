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
    var entity: BookEntity?
    
    typealias entityType = BookEntity
    
    // Expressions
    let name = Expression<String>("name")
    let userFK = Expression<Int64>("userId")
    
    // References
    let users = Table(AppConstraints.userTableName)
    
    var tableName: String {
        return AppConstraints.bookTableName
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
            t.column(userFK)
            t.foreignKey(userFK, references: users, id, delete: .cascade)
        }
    }
    
    var insertExpression: Insert {
        
        // TODO: check whether the new model name is already existed or not
        
        return table.insert(name <- entity!.name, userFK <- entity!.userId, status <- entity!.status)
    }

    var updateExpression: Update {
        
        // TODO: check whether the updating model name is already existed or not
        
        return table.filter(id == entity!.id!).update(name <- entity!.name, status <- entity!.status)
    }
 
    var deleteExpression: Delete {
        return table.filter(id == entity!.id!).delete()
    }
    
    
    func getAllBy(userIdentifier userId: Int64) throws -> [Book] {
        var result = [Book]()
                
        guard let database = SQLiteDataAccessLayer.shared.db else { throw DataAccessError.Datastore_Connection_Error }
        
        let bookSongRepository = BookSongRepository()
        
        for row in try database.prepare(table.filter(userFK == userId).filter(status == true).order(created))
        {
            let songCount = try? bookSongRepository.getTotalSongCount(by: row[id])
            result.append(Book(localId: row[id], name: row[name], createdDate: row[created], songCount: songCount ?? 0))
        }
        
        return result
    }
}
