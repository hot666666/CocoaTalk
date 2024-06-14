//
//  Chat.swift
//  CocoaTalk
//
//  Created by hs on 6/13/24.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    var id: String { chatId }
    
    var lastMessage: String {
        if let message {
            return message
        } else if let _ = photoURL {
            return "사진"
        } else {
            return "내용없음"
        }
    }
}

extension Chat {
    func toObject() -> ChatObject {
        .init(chatId: chatId,
              userId: userId,
              message: message,
              photoURL: photoURL,
              date: date.timeIntervalSince1970)
    }
}

extension Chat {
    static let stubs: [Chat] = [
        .init(chatId: UUID().uuidString, userId: "윤지디", message: "새로운 메시지", photoURL: nil, date: .now),
        .init(chatId: UUID().uuidString, userId: "나", message: "또 다른 메시지", photoURL: nil, date: .now),
        .init(chatId: UUID().uuidString, userId: "윤지디", message: "마지막 메시지", photoURL: nil, date: .now),
        .init(chatId: UUID().uuidString, userId: "윤지디", message: "새로운 메시지", photoURL: nil, date: .now),
        .init(chatId: UUID().uuidString, userId: "나", message: "또 다른 메시지", photoURL: nil, date: .now),
        .init(chatId: UUID().uuidString, userId: "윤지디", message: "마지막 메시지", photoURL: nil, date: .now)
    ]
    
    static let stub: Chat = .init(chatId: UUID().uuidString, userId: "윤지디", message: "새로운 메시지", photoURL: nil, date: .now)
}

extension Array where Element == Chat {
    // 채팅 배열을 년, 월, 일 단위로 그룹화하는 메서드
    func groupedByYearMonthDay() -> [[Chat]] {
        let calendar = Calendar.current
        // 채팅을 년, 월, 일 단위로 그룹화
        let groupedChats = Dictionary(grouping: self) { (chat) -> DateComponents in
            return calendar.dateComponents([.year, .month, .day], from: chat.date)
        }
        // 그룹화된 딕셔너리를 배열로 변환
        return groupedChats.values.map { Array($0) }.sorted { $0.first!.date < $1.first!.date }
    }
}
