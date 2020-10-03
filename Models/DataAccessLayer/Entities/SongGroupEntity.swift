//
//  BookEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct SongGroupEntity: BaseEntity {
    
    // Primary-key
    var id: Int64?
    
    // Reference
    var userId: Int64
    
    // Fields
    var name: String
    var status: Bool = true
    var type: SongGroupType
    
    static func create(from: SongGroup) -> SongGroupEntity {
        return SongGroupEntity(id: from.localId, userId: 0, name: from.name, type: from.type)
    }
    
}

enum SongGroupType: String {
    case book = "book"
    case category = "category"
}
