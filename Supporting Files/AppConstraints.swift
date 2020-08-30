//
//  AppConstraints.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 27.08.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct AppConstraints {
    static let storyboardName = "Main"
    static let welcomeViewControllerStoryboardId = "WelcomeViewController"
    static let homeViewControllerStoryboardId = "HomeViewController"
    static let firstEntryKey = "isFirstEntry"
    static let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static let bookCellIdentifier = "bookCell"
}
