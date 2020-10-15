//
//  BookSongEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct SongGroupSongEntity: BaseEntity {
    // Primary-key
    var id: Int64?
    
    // References
    var groupId: Int64
    var songId: Int64
    var songIndex: Int64
    

    static func create(from: SongGroup, and: Song) -> SongGroupSongEntity {
        return SongGroupSongEntity(groupId: from.localId, songId: and.id, songIndex: and.index ?? 0)
    }
    
}
