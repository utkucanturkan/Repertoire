//
//  BookSongEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct BookSong:EntityProtocol {
    
    // Queries
    let bookSong = Table("bookSong")
    
    // Expressions
    let bookSongId = Expression<Int64>("id")
    let bookFK = Expression<Int64>("bookId")
    let songFK = Expression<Int64>("songId")
    
    // References
    let books = Table("books")
    let bookId = Expression<Int64>("id")
    
    let songs = Table("songs")
    let songId = Expression<Int64>("id")
    
    func createTable(connection: Connection) {
        do {
            try connection.run(bookSong.create(ifNotExists: true) { t in
                t.column(bookSongId, primaryKey: .autoincrement)
                t.column(bookFK)
                t.column(songFK)
                t.foreignKey(bookFK, references: books, bookId, delete: .cascade)
                t.foreignKey(songFK, references: songs, songId, delete: .cascade)
            })
        } catch {
            
        }
    }
}
