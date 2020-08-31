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
    
    // References
    let books = Table("books")
    let bookId = Expression<Int64>("id")
    
    let songs = Table("songs")
    let songId = Expression<Int64>("id")
    
    var tableName: String {
        return "bookSong"
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(bookFK)
            t.column(songFK)
            t.foreignKey(bookFK, references: books, bookId, delete: .cascade)
            t.foreignKey(songFK, references: songs, songId, delete: .cascade)
        }
    }
    
    var insertExpression: Insert {
        return table.insert(bookFK <- model!.bookId, songFK <- model!.songId)
    }
            
    var deleteExpression: Delete {
        return table.filter(id == model!.id).delete()
    }
    
    var updateExpression: Update {
        return table.filter(id == model!.id).update(bookFK <- model!.bookId, songFK <- model!.songId)
    }
    
    func getSongCountBy(bookId bId: Int64) throws -> Int {
        guard let database = SQLiteDataAccessLayer.shared.db else { throw DataAccessError.Datastore_Connection_Error }
        return try database.scalar(table.filter(bookFK == bId).count)
    }
    
}
