//
//  UserEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct User: EntityProtocol {
    var id: Int64
    var userName: String
    var status: Bool
}
