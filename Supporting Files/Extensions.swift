//
//  Extensions.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 3.09.2020.
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

extension UserDefaults {
    func setEncodable<Object>(object item: Object, with key:String) throws where Object: Encodable {
        do {
            let object = try JSONEncoder().encode(item)
            set(object, forKey: key)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getDecodable<Object>(with key: String, by type: Object.Type) throws -> Object where Object: Decodable {
        guard let object = data(forKey: key) else {
            throw ObjectSavableError.noValue
        }
        
        do {
            return try JSONDecoder().decode(type, from: object)
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
