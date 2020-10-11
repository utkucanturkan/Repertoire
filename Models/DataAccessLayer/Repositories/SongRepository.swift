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
    typealias entityType = SongEntity
    
    var entity: SongEntity?

    // Expressions
    let name = Expression<String>("name")
    let content = Expression<String?>("content")
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
            t.unique(userFK, name)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(name        <- entity!.name,
                            userFK      <- entity!.userId,
                            content     <- entity!.content,
                            mediaUrl    <- entity!.mediaUrl,
                            status      <- entity!.status)
    }
    
    var updateExpression: Update {
        return table.filter(id == entity!.id!)
                    .update(name        <- entity!.name,
                            content     <- entity!.content,
                            mediaUrl    <- entity!.mediaUrl,
                            status      <- entity!.status)
    }
    
    var deleteExpression: Delete {
        return table.filter(id == entity!.id!)
                    .delete()
    }
    
    func getAll(by groupIdentifier: Int64?) throws -> [Song]  {
        let songGroupTable = Table(AppConstraints.SongGroupSongTableName)
        let songFK = Expression<Int64>("songId")
        let songIndex = Expression<Int64>("songIndex")
        let groupFK = Expression<Int64>("bookId")
        
        var result = [Song]()
        
        guard let database = SQLiteDataAccessLayer.shared.db else {
            throw DataAccessError.Datastore_Connection_Error
        }

        var query = table.order(name.asc)
        
        if let groupIdentifier = groupIdentifier {
            query = table.join(songGroupTable, on: table[id] == songGroupTable[songFK])
                         .select(table[id], name, songIndex, groupFK)
                         .filter(groupFK == groupIdentifier)
                         .order(songIndex.asc)
        }
        
        try database.prepare(query).forEach { row in
            result.append(Song(id: row[id],
                               name: row[name],
                               index: groupIdentifier == nil ? 0 : row[songIndex]))
        }
        
        return result
    }
    
    func getAllDistinct(from identifiers: Int64...) throws -> [Song] {
        var result = [Song]()
        
        guard let database = SQLiteDataAccessLayer.shared.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(!identifiers.contains(id))
        
        try database.prepare(query).forEach { row in
            result.append(Song(id: row[id],
                               name: row[name],
                               categories: nil))
        }
        
        return result
    }
    
}
