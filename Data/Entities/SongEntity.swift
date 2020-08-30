//
//  SongEntity.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct Song: EntityProtocol {

    var name: String
    var content: String
    var mediaUrl: String
    var status: Bool
    
}
