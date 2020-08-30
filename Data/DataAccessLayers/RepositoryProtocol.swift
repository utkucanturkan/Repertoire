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
    var tableName: String { get }
    
    func delete(item: Entity) throws -> Void
    func findAll() throws -> [Entity]?
}


extension RepositoryProtocol {
    var table: Table {
        return Table(tableName)
    }
    
    func insert(item: Entity) throws -> Int64 {
        return try SQLiteDataAccessLayer.shared.insert(insertExpression: insertExpression)
    }
    
    func createTable() throws {
        try SQLiteDataAccessLayer.shared.createTable(createTableExpression: createTableExpression)
    }
    
}
