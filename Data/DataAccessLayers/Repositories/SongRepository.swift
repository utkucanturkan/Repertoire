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
    
    func getAll(by bookIdentifier: Int64) throws -> [SongViewModel]  {
        var result = [SongViewModel]()
        
        guard let database = SQLiteDataAccessLayer.shared.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let bookSongTable = Table(AppConstraints.bookSongTableName)
        let songFK = Expression<Int64>("songId")
        let songIndex = Expression<Int64>("songIndex")
        let bookFK = Expression<Int64>("bookId")

        let query = table.join(bookSongTable, on: table[id] == bookSongTable[songFK])
            .select(table[id], name, songIndex, bookFK)
            .filter(bookFK == bookIdentifier)
            .order(songIndex.asc)
        	
        for row in try database.prepare(query) {
            result.append(SongViewModel(id: row[id], name: row[name], index: row[songIndex]))
        }
        
        return result
    }
}
