//
//  BookEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct BookEntity: BaseEntity {
    
    // Primary-key
    var id: Int64?
    
    // Reference
    var userId: Int64
    
    // Fields
    var name: String
    var status: Bool = true
}
