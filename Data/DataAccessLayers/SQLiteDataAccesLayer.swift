//
//  SQLiteDataAccesLayer.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Update_Error
    case Search_Error
    case Nil_In_Data
}

struct SQLiteDataAccessLayer {
    static let shared = SQLiteDataAccessLayer()
    
    private let dbPath = "\(AppConstraints.databasePath)/db.sqlite3"
    
    let db: Connection?
    
    private init() {
        do {
            db = try Connection(dbPath)
        } catch _ {
            db = nil
        }
    }
    
    /*
    static func initializeDatabase(repositories: [RepositoryProtocol]) {
        for repository in repositories {
            repository.createTable()
        }
    }
    */
    func createTable(expression: String) throws {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            try database.run(expression)
        } catch _ {
            // thrown an error if table already exists
        }
    }
    
    // CRUD
    
    func insert(expression: Insert) throws -> Int64 {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let rowId = try database.run(expression)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            return rowId
        } catch _ {
            throw DataAccessError.Insert_Error
        }
    }
    
    func update(expression: Update) throws {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let tmp = try database.run(expression)
            guard tmp > 0 else {
                throw DataAccessError.Update_Error
            }
        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    func delete(expression: Delete) throws {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let tmp = try database.run(expression)
            guard tmp > 0 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
}
