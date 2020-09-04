//
//  BookSongRepository.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct BookSongRepository: RepositoryProtocol {
    typealias Entity = BookSong
    
    var model: BookSong?
    
    // Expressions
    let bookFK = Expression<Int64>("bookId")
    let songFK = Expression<Int64>("songId")
    let songIndex = Expression<Int64>("songIndex")
    
    // References
    let books = Table(AppConstraints.bookTableName)
    let songs = Table(AppConstraints.songTableName)
    
    var tableName: String {
        return AppConstraints.bookSongTableName
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(bookFK)
            t.column(songFK)
            t.column(songIndex)
            t.foreignKey(bookFK, references: books, id, delete: .cascade)
            t.foreignKey(songFK, references: songs, id, delete: .cascade)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(bookFK <- model!.bookId, songFK <- model!.songId, songIndex <- model!.songIndex)
    }
            
    var deleteExpression: Delete {
        return table.filter(id == model!.id!).delete()
    }
    
    var updateExpression: Update {
        return table.filter(id == model!.id!).update(bookFK <- model!.bookId, songFK <- model!.songId, songIndex <- model!.songIndex)
    }
    
    func getSongCountBy(bookIdentifier bId: Int64) throws -> Int {
        guard let database = SQLiteDataAccessLayer.shared.db else { throw DataAccessError.Datastore_Connection_Error }
        return try database.scalar(table.filter(bookFK == bId).count)
    }
    
}
