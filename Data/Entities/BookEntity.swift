//
//  BookEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct Book: EntityProtocol {
    var id: Int64
    var name: String
    var userId: Int64
    var status: Bool
}
