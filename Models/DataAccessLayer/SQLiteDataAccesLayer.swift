//
//  SQLiteDataAccesLayer.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 30.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation
import SQLite

struct SQLiteDataAccessLayer {
    static let shared = SQLiteDataAccessLayer()
    
    private let dbPath = "\(AppConstraints.databasePath)/db.sqlite3"
    
    let repositories: [InitializableRepository] = [UserRepository(),
                                                   SongGroupRepository(),
                                                   SongRepository(),
                                                   SongGroupSongRepository()]
        
    let db: Connection?
    
    private init() {
        do {
            db = try Connection(dbPath)
        } catch _ {
            db = nil
        }
    }
    
    func initializeDatabase(with dataSeeder: DataSeederProtocol?) {
        do {
            for initializableRepository in repositories {
               try initializableRepository.createTable()
            }
            
            if let seeder = dataSeeder {
                seeder.seed()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func initializeDatabase() {
        initializeDatabase(with: nil)
    }
    
    
    
    func createTable(expression: String) throws {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            try database.run(expression)
        } catch {
            print(error.localizedDescription)
            
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
    
    func update(expression: Update) throws -> Int {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let rowId = try database.run(expression)
            guard rowId > 0 else {
                throw DataAccessError.Update_Error
            }
            return rowId
        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    func delete(expression: Delete) throws -> Int {
        guard let database = db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let rowId = try database.run(expression)
            guard rowId > 0 else {
                throw DataAccessError.Delete_Error
            }
            return rowId
        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
}
