//
//  UserEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct UserEntity: BaseEntity {
    
    // Primary-key
    var id: Int64?
    
    // Fields
    var globalId: String?
    var name: String = AppConstraints.defaultLocalUserName
    var status: Bool = true
}
