//
//  UserRepository.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct UserRepository: RepositoryProtocol {
    var model: User?
    
    typealias Entity = User
        
    // Expressions
    let userName = Expression<String>("userName")
    
    var tableName: String {
        return "users"
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(userName)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        }
    }

    var insertExpression: Insert {
        return table.insert(userName <- model!.userName, status <- model!.status)
    }
    
    var updateExpression: Update {
        return table.filter(id == model!.id).update(userName <- model!.userName, status <- model!.status)
    }
    
    var deleteExpression: Delete {
        return table.filter(id == model!.id).delete()
    }
}
