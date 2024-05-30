//
//  User.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

struct User: Identifiable {
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
