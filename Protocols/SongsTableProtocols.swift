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

protocol TableProtocol { var songGroup: SongGroup? { get set } }

struct SongsOfGroupListingTable: Addedable, Deletable, Movable {
    var songGroup: SongGroup?
}

struct NewSongAdditionTable: TableProtocol {
    var songGroup: SongGroup?
}

struct AllSongsListingTable: Addedable, Deletable, Indexable {
    var songGroup: SongGroup?
}
