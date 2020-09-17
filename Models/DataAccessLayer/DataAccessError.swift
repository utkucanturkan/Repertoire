//
//  DataAccessError.swift
//  Repertoire
//
//  Created by Utkucan Türkan on 17.09.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Update_Error
    case Search_Error
    case Nil_In_Data
}
