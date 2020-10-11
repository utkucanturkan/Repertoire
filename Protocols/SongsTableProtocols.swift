//
//  SongsTableProtocols.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.10.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

protocol Addedable: TableProtocol { }

protocol Deletable: TableProtocol { }

protocol Movable: TableProtocol { }

protocol Indexable: TableProtocol { }

protocol TableProtocol {
    var songGroup: SongGroup? { get set }

    func getSongs() throws -> [Song]
}
    
extension TableProtocol {
    var songRepository: SongRepository {
        return SongRepository()
    }
}

struct SongsOfGroupListingTable: Addedable, Deletable, Movable {
    func getSongs() throws -> [Song] {
        
    }
    

    var songGroup: SongGroup?
}

struct NewSongAdditionTable: TableProtocol {
    func getSongs() throws -> [Song] {
        
    }
    
    var songGroup: SongGroup?
}

struct AllSongsListingTable: Addedable, Deletable, Indexable {
    func getSongs() throws -> [Song] {
        return try songRepository.getAll(by: 1)
    }
    
    var songGroup: SongGroup?
}
