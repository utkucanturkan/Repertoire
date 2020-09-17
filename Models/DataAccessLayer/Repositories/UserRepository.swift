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
    var entity: UserEntity?
    
    typealias entityType = UserEntity
        
    // Expressions
    let name = Expression<String>("name")
    let globalId = Expression<String?>("globalId")
    
    var tableName: String {
        return AppConstraints.userTableName
    }
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(globalId)
            t.column(name)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        }
    }

    var insertExpression: Insert {
        return table.insert(name <- entity!.name, globalId <- entity!.globalId, status <- entity!.status)
    }
    
    var updateExpression: Update {
        return table.filter(id == entity!.id!).update(name <- entity!.name, status <- entity!.status)
    }
    
    var deleteExpression: Delete {
        return table.filter(id == entity!.id!).delete()
    }
}
