//
//  SongRepository.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct SongRepository: RepositoryProtocol {
    var model: Song?
    
    typealias Entity = Song
        
    // Expressions
    let name = Expression<String>("name")
    let content = Expression<String>("content")
    let mediaUrl = Expression<String?>("mediaUrl")
    let userFK = Expression<Int64>("userId")
    
    // References
    let users = Table(AppConstraints.userTableName)
    
    var tableName: String {
        return AppConstraints.songTableName
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name)
            t.column(content)
            t.column(mediaUrl)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
            t.column(userFK)
            t.foreignKey(userFK, references: users, id, delete: .cascade)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(name <- model!.name, content <- model!.content, mediaUrl <- model!.mediaUrl, status <- model!.status)
    }
    
    var updateExpression: Update {
        return table.filter(id == model!.id!).update(name <- model!.name, content <- model!.content, mediaUrl <- model!.mediaUrl, status <- model!.status)
    }
    
    var deleteExpression: Delete {
        return table.filter(id == model!.id!).delete()
    }
}
