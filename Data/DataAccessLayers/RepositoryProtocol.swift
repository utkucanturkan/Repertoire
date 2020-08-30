//
//  RepositoryProtocol.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

protocol RepositoryProtocol {
    associatedtype Entity: EntityProtocol
    
    var createTableExpression: String { get }
    
    var insertExpression: Insert { get }
    var deleteExpression: Delete { get }
    var updateExpression: Update { get }
    
    var tableName: String { get }
    
    var model: Entity { get set }
}


extension RepositoryProtocol {
    var id: Expression<Int64> { return Expression<Int64>("id") }
    
    var created: Expression<Date> { return Expression<Date>("created") }
    
    var updated: Expression<Date?> { return Expression<Date?>("updated") }
    
    var status: Expression<Bool> { return Expression<Bool>("status") }
    
    var table: Table {
        return Table(tableName)
    }
    
    func createTable() throws {
        try SQLiteDataAccessLayer.shared.createTable(createTableExpression: createTableExpression)
    }
    
    // CRUD
    func insert(item: Entity) throws -> Int64 {
        return try SQLiteDataAccessLayer.shared.insert(insertExpression: insertExpression)
    }
    
    func delete(item: Entity) throws {
        try SQLiteDataAccessLayer.shared.delete(entity: item, deleteExpression: deleteExpression)
    }
    
    func update(item: Entity) throws {
        try SQLiteDataAccessLayer.shared.update(entity: item, updateExpression: updateExpression)
    }
}
