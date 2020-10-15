//
//  BookSongRepository.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct SongGroupSongRepository: RepositoryProtocol {
    typealias entityType = SongGroupSongEntity
    
    var entity: SongGroupSongEntity?
    
    // Expressions
    let groupFK = Expression<Int64>("bookId")
    let songFK = Expression<Int64>("songId")
    let songIndex = Expression<Int64>("songIndex")
    
    // References
    let songGroups = Table(AppConstraints.songGroupTableName)
    let songs = Table(AppConstraints.songTableName)
    
    var tableName: String {
        return AppConstraints.SongGroupSongTableName
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(groupFK)
            t.column(songFK)
            t.column(songIndex)
            t.foreignKey(groupFK, references: songGroups, id, delete: .cascade)
            t.foreignKey(songFK, references: songs, id, delete: .cascade)
            t.unique(groupFK, songFK)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(groupFK     <- entity!.groupId,
                            songFK      <- entity!.songId,
                            songIndex   <- entity!.songIndex)
    }
            
    var deleteExpression: Delete {
        return table.filter(groupFK == entity!.groupId)
                    .filter(songFK == entity!.songId)
                    .delete()
    }
    
    var updateExpression: Update {
        return table.filter(id == entity!.id!)
                    .update(groupFK     <- entity!.groupId,
                            songFK      <- entity!.songId,
                            songIndex   <- entity!.songIndex)
    }
    
    func getTotalSongCount(by bookIdentifier: Int64) throws -> Int {
        guard let database = SQLiteDataAccessLayer.shared.db else { throw DataAccessError.Datastore_Connection_Error }
        return try database.scalar(table.filter(groupFK == bookIdentifier).count)
    }
    
    func getSongIds(by groupIdentifier: Int64) throws -> [Int64] {
        guard let database = SQLiteDataAccessLayer.shared.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(groupFK == groupIdentifier)
        
        var ids = [Int64]()
        
        try database.prepare(query).forEach { row in
            ids.append(row[songFK])
        }
        
        return ids
    }
}
