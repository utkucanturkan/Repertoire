//
//  SongEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct SongEntity: BaseEntity {
    
    // Primary-key
    var id: Int64?
    
    // Reference
    var userId: Int64
    
    // Fields
    var name: String
    var content: String?
    var mediaUrl: String?
    var status: Bool = true
    
    
    
    static func create(from: Song) -> SongEntity {
        return SongEntity(id: from.id, userId: 0, name: from.name)
    }
    
}
