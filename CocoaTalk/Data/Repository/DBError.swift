//
//  DBError.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}
