//
//  NavigationDestination.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search(userId: String)
}
