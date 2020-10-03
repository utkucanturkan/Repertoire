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
                _ = try songRepository.insert(element: SongEntity(userId: 1, name: "Song Name", content: "Contrary to popular belief, Lorem Ipsum is not simply random text. ", mediaUrl: "https://youtube.com")
                    )
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        //songs.forEach { _ = try? songRepository.insert(element: $0) }
    }
}
