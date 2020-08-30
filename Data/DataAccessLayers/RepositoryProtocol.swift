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
    
    var model: Entity? { get set }
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
        try SQLiteDataAccessLayer.shared.createTable(expression: createTableExpression)
    }
    
    // CRUD
    mutating func insert(element: Entity) throws -> Int64 {
        model = element
        return try SQLiteDataAccessLayer.shared.insert(expression: insertExpression)
    }
    
    mutating func delete(element: Entity) throws {
        model = element
        try SQLiteDataAccessLayer.shared.delete(expression: deleteExpression)
    }
    
    mutating func update(element: Entity) throws {
        model = element
        try SQLiteDataAccessLayer.shared.update(expression: updateExpression)
    }
}
