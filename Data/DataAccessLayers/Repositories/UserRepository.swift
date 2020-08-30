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
    
    // Query
    let users = Table("users")
    
    // Expressions
    let created = Expression<Date>("created")
    let updated = Expression<Date?>("updated")
    let status = Expression<Bool>("status")
    let userId = Expression<Int64>("id")
    let userName = Expression<String>("userName")
    
    var createTableExpression: String {
        return table.create(ifNotExists: true) { t in
            t.column(userId, primaryKey: .autoincrement)
            t.column(userName)
            t.column(created, defaultValue: Date())
            t.column(updated)
            t.column(status, defaultValue: true)
        }
    }
    
    var tableName: String {
        return "users"
    }
    
    var insertExpression: Insert {
        return table.insert()
    }
    
    func createTable() throws {
        
    }
    
    func delete(item: User) throws {
        
    }
    
    func findAll() throws -> [User]? {
        return nil
    }
    
    typealias Entity = User
}
