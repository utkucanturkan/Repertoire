//
//  BookSongEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct BookSong: EntityProtocol {
    
    // Primary-key
    var id: Int64?
    
    // References
    var bookId: Int64
    var songId: Int64
}
