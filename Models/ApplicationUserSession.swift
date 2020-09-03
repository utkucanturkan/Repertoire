//
//  ApplicationUserSession.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

class ApplicationUserSession: Codable {
    
    init(localId: Int64, globalId: String?, userName: String) {
        self.localId = localId
        self.globalId = globalId
        self.userName = userName
    }
    
    var islocal: Bool {
        return globalId == nil
    }
    
    var localId: Int64
    var globalId: String?
    var userName: String = AppConstraints.defaultLocalUserName
}
