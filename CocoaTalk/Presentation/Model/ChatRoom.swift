//
//  ChatRoom.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

struct ChatRoom: Hashable {
    var chatRoomId: String
    var lastMessage: String?
    var lastMessageDate: String?
    var otherUserName: String
    var otherUserId: String
}

extension ChatRoom {
    func toObject() -> ChatRoomObject {
        .init(chatRoomId: chatRoomId,
              lastMessage: lastMessage,
              lastMessageDate: lastMessageDate,
              otherUserName: otherUserName,
              otherUserId: otherUserId)
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "chatRoom1_id", lastMessage: "안녕", lastMessageDate: Date.now.fullDateString, otherUserName: "친구1", otherUserId: "user1_id")
    }
    
    static var stub2: ChatRoom {
        .init(chatRoomId: "chatRoom2_id", otherUserName: "친구2", otherUserId: "user2_id")
    }
}
