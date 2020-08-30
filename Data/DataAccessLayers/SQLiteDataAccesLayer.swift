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
    case Search_Error
    case Nil_In_Data
}

struct SQLiteDataAccessLayer {
    static let shared = SQLiteDataAccessLayer()
    
    private let dbPath = "\(AppConstraints.databasePath)/db.sqlite3"
    
    private let db: Connection?
    
    private init() {
        do {
            db = try Connection(dbPath)
        } catch _ {
            db = nil
        }
    }
    
    func insert(insertExpression: Insert) throws -> Int64 {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let rowId = try database.run(insertExpression)
            
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            
            return rowId
        } catch _ {
            throw DataAccessError.Insert_Error
        }
    }
    
    
    
    func createTable(createTableExpression: String) throws {
        
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            try database.run(createTableExpression)
        } catch _ {
            // thrown an error if table already exists
        }
        
    }
     
}
