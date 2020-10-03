//
//  SongsTableProtocols.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.10.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

protocol AddedableTable: SongTableProtocol { }

protocol DeletableTable: SongTableProtocol { }

protocol MovableTable: SongTableProtocol { }

protocol SongTableProtocol { var songGroup: SongGroup? { get set } }

struct SongsTableOfGroup: AddedableTable, DeletableTable, MovableTable {
    var songGroup: SongGroup?
}

struct SongTableOfNewSongForGroup: SongTableProtocol {
    var songGroup: SongGroup?
}

struct SongTableDefault: AddedableTable, DeletableTable {
    var songGroup: SongGroup?
}
