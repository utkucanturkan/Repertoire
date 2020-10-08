//
//  DatabaseSeedManager.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.10.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

class DatabaseSeedManager: DataSeederProtocol {
    
    private var songRepository = SongRepository()
    
    func seed() {
        seedSongs()
    }
    
    private func seedSongs() {
        for _ in 1...30 {            
            do {
                let asciiValue: UInt8 = UInt8.random(in: 65...90)
                let c = Character(UnicodeScalar(asciiValue))
                _ = try songRepository.insert(element: SongEntity(userId: 1, name: "\(c) Song", content: "Contrary to popular belief, Lorem Ipsum is not simply random text. ", mediaUrl: "https://youtube.com")
                    )
            } catch {
                print("[ERROR] - Seeding songs!")
            }
        }
    }
}
