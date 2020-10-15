//
//  SongsTableProtocols.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.10.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

protocol TableProtocol {
    var songGroup: SongGroup? { get set }
    
    var songRepository: SongRepository { get set }
    
    func getSongs() throws -> [Song]
}

protocol Addedable: TableProtocol { }
protocol Deletable: TableProtocol { }
protocol Movable: TableProtocol { }
protocol Indexable: TableProtocol { }
protocol MultiSelectable { }
    
extension TableProtocol {
    func getSongs() throws -> [Song] {
        return try songRepository.getAll(by: songGroup?.localId)
    }
    
    mutating func delete(song: Song) throws {
        let entity = SongEntity.create(from: song)
        try songRepository.delete(element: entity)
    }
}

struct SongsOfGroupListingTable: Addedable, Deletable, Movable {
    var songGroup: SongGroup?
    var songRepository = SongRepository()
    
    func delete(song: Song) throws {
        var songGroupSongRepository = SongGroupSongRepository()
        if let group = songGroup {
            let entity = SongGroupSongEntity.create(from: group, and: song)
            try songGroupSongRepository.delete(element: entity)
        }
    }
}

struct NewSongAdditionTable: TableProtocol, MultiSelectable {
    var songGroup: SongGroup?
    var songRepository = SongRepository()
    
    func getSongs() throws -> [Song] {
        if let group = songGroup {
            return try songRepository.getAllDistinct(of: group.localId)
        }
        return try songRepository.getAll(by: nil)
    }
}

struct AllSongsListingTable: Addedable, Deletable, Indexable {
    var songGroup: SongGroup?
    var songRepository = SongRepository()
}
