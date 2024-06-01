//
//  UserObject.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation

struct UserObject: Codable {
    var id: String
    var name: String
    var profileURL: String?
    var phoneNumber: String?
    var description: String?
}

extension UserObject {
    func toModel() -> User {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}
