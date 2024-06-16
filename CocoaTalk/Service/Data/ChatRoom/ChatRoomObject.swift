//
//  ChatRoomObject.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

struct ChatRoomObject: Codable {
    var chatRoomId: String
    var lastMessage: String?
    var lastMessageDate: String?
    var otherUserName: String
    var otherUserId: String
}

extension ChatRoomObject {
    func toModel() -> ChatRoom {
        .init(chatRoomId: chatRoomId,
              lastMessage: lastMessage,
              lastMessageDate: lastMessageDate,
              otherUserName: otherUserName,
              otherUserId: otherUserId)
    }
}

extension ChatRoomObject {
    static var stub1: ChatRoomObject {
        .init(chatRoomId: "chatRoom1_id",
              otherUserName: "user2",
              otherUserId: "user2_id")
    }
}
