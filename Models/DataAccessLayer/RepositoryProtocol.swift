//
//  RepositoryProtocol.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

protocol InitializableRepository {
    var createTableExpression: String { get }
}

extension InitializableRepository {
    func createTable() throws {
        try SQLiteDataAccessLayer.shared.createTable(expression: createTableExpression)
    }
}

protocol RepositoryProtocol: InitializableRepository {
    associatedtype entityType: BaseEntity

    var insertExpression: Insert { get }
    var deleteExpression: Delete { get }
    var updateExpression: Update { get }
    
    var tableName: String { get }
    
    var entity: entityType? { get set }
}

extension RepositoryProtocol {
    var id: Expression<Int64> { return Expression<Int64>("id") }
    var created: Expression<Date> { return Expression<Date>("created") }
    var updated: Expression<Date?> { return Expression<Date?>("updated") }
    var status: Expression<Bool> { return Expression<Bool>("status") }
    
    var table: Table {
        return Table(tableName)
    }

    // CRUD
    mutating func insert(element: entityType) throws -> Int64 {
        entity = element
        return try SQLiteDataAccessLayer.shared.insert(expression: insertExpression)
    }
    
    mutating func delete(element: entityType) throws {
        entity = element
        guard let _ = element.id else {
            throw DataAccessError.Nil_In_Data
        }
        _ = try SQLiteDataAccessLayer.shared.delete(expression: deleteExpression)
    }
    
    mutating func update(element: entityType) throws {
        entity = element
        guard let _ = element.id else {
            throw DataAccessError.Nil_In_Data
        }
        _ = try SQLiteDataAccessLayer.shared.update(expression: updateExpression)
    }
}
