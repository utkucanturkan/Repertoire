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
    var entity: SongEntity?
    
    typealias entityType = SongEntity
        
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
        return table.insert(name <- entity!.name, content <- entity!.content, mediaUrl <- entity!.mediaUrl, status <- entity!.status)
    }
    
    var updateExpression: Update {
        return table.filter(id == entity!.id!).update(name <- entity!.name, content <- entity!.content, mediaUrl <- entity!.mediaUrl, status <- entity!.status)
    }
    
    var deleteExpression: Delete {
        return table.filter(id == entity!.id!).delete()
    }
    
    func getAll(_ bookIdentifier: Int64? = nil) throws -> [Song]  {
        var result = [Song]()
        
        guard let database = SQLiteDataAccessLayer.shared.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let bookSongTable = Table(AppConstraints.bookSongTableName)
        let songFK = Expression<Int64>("songId")
        let songIndex = Expression<Int64>("songIndex")
        let bookFK = Expression<Int64>("bookId")

        var query = table.join(bookSongTable, on: table[id] == bookSongTable[songFK])
            .select(table[id], name, songIndex, bookFK)
        
        if let bookIdentifier = bookIdentifier {
            query = query.filter(bookFK == bookIdentifier)
        }
        	
        for row in try database.prepare(query.order(songIndex.asc)) {
            result.append(Song(id: row[id], name: row[name], index: row[songIndex]))
        }
        
        return result
    }
}
