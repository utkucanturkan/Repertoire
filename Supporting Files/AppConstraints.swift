//
//  AppConstraints.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct AppConstraints {
    
    // Storyboard Identifiers
    static let storyboardName = "Main"
    static let welcomeViewControllerStoryboardId = "WelcomeViewController"
    static let homeViewControllerStoryboardId = "HomeViewController"
    
    // Userdefault Keys
    static let firstEntryKey = "isFirstEntry"
    static let userLocalIdKey = "userLocalId"
    
    // Cell Identifiers
    static let bookCellIdentifier = "bookCell"
    
    // Segue Identifiers
    static let bookViewControllerSegueIdentifier = "BookViewControllerSegue"
    
    // Local Database
    static let localUserName = "localUser"
    static let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static let userTableName = "users"
    static let songTableName = "songs"
    static let bookTableName = "books"
    static let bookSongTableName = "bookSong"
}
