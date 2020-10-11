//
//  DatabaseSeedManager.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.10.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

class DatabaseSeedManager: DataSeederProtocol {
    
    // MARK: Constants
    private var defaultUserId: Int64 { return 1 }
    
    // MARK: Repositories
    private var songRepository = SongRepository()
    private var songGroupRepository = SongGroupRepository()
    private var songGroupSongRepository = SongGroupSongRepository()
    
    private var insertedSongIds = [Int64]()
    
    private var randomChar: Character {
        let asciiValue: UInt8 = UInt8.random(in: 65...90)
        let c = Character(UnicodeScalar(asciiValue))
        return c
    }
    
    func seed() {
        seedSongs()
        seedCategories()
        seedBooks()
    }
    
    private func seedSongs() {
        for _ in 1...15 {
            do {
                let songId = try songRepository.insert(element: SongEntity(userId: defaultUserId, name: "\(randomChar) Song", content: "Contrary to popular belief, Lorem Ipsum is not simply random text. ", mediaUrl: "https://youtube.com"))
                insertedSongIds.append(songId)
            } catch {
                print("[ERROR] - Seeding songs!")
            }
        }
    }
    
    private func seedCategories() {
        for _ in 1...5 {
            do {
                let categoryId = try songGroupRepository.insert(element: SongGroupEntity(userId: defaultUserId, name: "\(randomChar) Category", type: .category))
                
                // Song adding to the categories
                for index in 1...3 {
                    let songId = insertedSongIds[Int.random(in: 0..<insertedSongIds.count)]
                    _ = try songGroupSongRepository.insert(element: SongGroupSongEntity(groupId: categoryId, songId: songId, songIndex: Int64(index)))
                }
            } catch {
                print("[ERROR] - Seeding categories!")
            }
        }
    }
    
    
    private func seedBooks() {
        for _ in 1...3 {
            do {
                let bookId = try songGroupRepository.insert(element: SongGroupEntity(userId: defaultUserId, name: "\(randomChar) Book", type: .book))
                
                // Song addition to the book
                for index in 1...5 {
                    let songId = insertedSongIds[Int.random(in: 0..<insertedSongIds.count)]
                    _ = try songGroupSongRepository.insert(element: SongGroupSongEntity(groupId: bookId, songId: songId, songIndex: Int64(index)))
                }
            } catch {
                print("[ERROR] - Seeding books!")
            }
        }
    }
    
}
