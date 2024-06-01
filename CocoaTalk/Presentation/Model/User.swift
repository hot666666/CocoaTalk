//
//  User.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

struct User: Identifiable, Hashable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
    
    init(id: String, name: String, phoneNumber: String? = nil, profileURL: String? = nil, description: String? = nil) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileURL = profileURL
        self.description = description
    }
}

extension User {
    func toObject() -> UserObject {
        .init(id: id,
              name: name,
              profileURL: profileURL,
              phoneNumber: phoneNumber,
              description: description
        )
    }
}

extension User {
    static let stubUser: User = .init(id: "user_id", name: "나이름")
    static let stubUsers: [User] = (1...10).map { User(id: "user_id\($0)", name: "친구이름\($0)") }  /// 10명
}
