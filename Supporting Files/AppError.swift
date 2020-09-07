//
//  AppError.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 7.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

enum SignInError: String, LocalizedError {
    case loginError = "A login error has been occurred"
}
