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
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(songId, primaryKey: .autoincrement)
            t.column(songName, unique: true)
            t.column(songContent)
            t.column(mediaUrl)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        }
    }
    
    var tableName: String {
        return "songs"
    }
    
    var insertExpression: Insert {
        return table.insert(songName <- model.name, songContent <- model.content, mediaUrl <- model.mediaUrl, status <- model.status)
    }
    
    var model: Song
    
    init(song: Song) {
        model = song
    }
    
    // Expressions
    let songId = Expression<Int64>("id")
    let songName = Expression<String>("name")
    let songContent = Expression<String>("content")
    let mediaUrl = Expression<String?>("mediaUrl")
    let created = Expression<Date>("created")
    let updated = Expression<Date?>("updated")
    let status = Expression<Bool>("status")

    func delete(item: Song) throws {
        
    }
    
    func findAll() throws -> [Song]? {
        return nil
    }
    
    typealias Entity = Song
    
    
}
