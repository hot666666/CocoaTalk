//
//  Constant.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation

typealias DBKey = Constant.DBKey

enum Constant { }

extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
        static let Friends = "Friends"
    }
}
