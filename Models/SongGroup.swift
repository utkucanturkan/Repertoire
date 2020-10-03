//
//  BookViewModel.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct SongGroup {
    var localId: Int64
    var globalId: String?
    var name: String
    var createdDate: Date = Date()
    var songCount: Int = 0
    var type: SongGroupType
}
