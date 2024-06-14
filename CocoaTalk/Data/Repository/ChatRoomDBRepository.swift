//
//  ChatRoomDBRepository.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, otherUserId: String) async throws -> ChatRoomObject?
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) async throws
    func loadChatRooms(myUserId: String) async throws -> [ChatRoomObject]
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String, lastMessageDate: Date) async throws
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    private var db: DatabaseReference
    
    init(reference: DBReferenceType = DBReference()) {
        db = Database.database().reference()
    }
    
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    func getChatRoom(myUserId: String, otherUserId: String) async throws -> ChatRoomObject? {
        let path = getPath(key: DBKey.ChatRooms, path: "\(myUserId)/\(otherUserId)")

        guard let snapshot = try? await db.child(path).getData() else {
            throw DBRepositoryError.getDataError
        }
        if !snapshot.exists() {
            throw DBRepositoryError.notFoundError
        }
        
        guard
            let data = snapshot.value,
            let jsonData = try? JSONSerialization.data(withJSONObject: data),
            /// Firebase Database는 NSNumber, NSString, NSDictionary, NSArray 타입의 객체만 사용
            /// 따라서 디코딩된 Data 객체를 Swift 타입으로 변환해야함
            let chatroomObj = try? JSONDecoder().decode(ChatRoomObject.self, from: jsonData)
        else {
            throw DBRepositoryError.decodingError
        }
        
        return chatroomObj
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) async throws {
        let otherObject: ChatRoomObject = .init(chatRoomId: object.chatRoomId, otherUserName: myUserId, otherUserId: object.otherUserId)
        
        guard
            let data = try? JSONEncoder().encode(object),
            let jsonEncodedChatRoom = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let otherData = try? JSONEncoder().encode(otherObject),
            let jsonEncodedOtherChatRoom = try? JSONSerialization.jsonObject(with: otherData, options: .allowFragments)
        else {
            throw DBRepositoryError.encodingError
        }

        let path = getPath(key: DBKey.ChatRooms, path: "\(myUserId)/\(object.otherUserId)")
        let otherPath = getPath(key: DBKey.ChatRooms, path: "\(object.otherUserId)/\(myUserId)")

        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try await self.db.child(path).setValue(jsonEncodedChatRoom)
                }
                group.addTask {
                    try await self.db.child(otherPath).setValue(jsonEncodedOtherChatRoom)
                }
                try await group.waitForAll()
            }
        } catch {
            throw DBRepositoryError.setValueError
        }
    }
    
    func loadChatRooms(myUserId: String) async throws -> [ChatRoomObject] {
        let path = getPath(key: DBKey.ChatRooms, path: myUserId)
        
        guard let snapshot = try? await db.child(path).getData() else {
            throw DBRepositoryError.getDataError
        }
        
        if !snapshot.exists() { return [] }
        
        guard
            let data = snapshot.value,
            let jsonData = try? JSONSerialization.data(withJSONObject: data),
            let chatRoomObject = try? JSONDecoder().decode([String: ChatRoomObject].self, from: jsonData)  /// []이 있다면 뒤에 .self 추가로 타입 의미
        else {
            throw DBRepositoryError.decodingError
        }
        
        return Array(chatRoomObject.values)
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String, lastMessageDate: Date) async throws {
        let values: [String: Any] = [
            "\(DBKey.ChatRooms)/\(myUserId)/\(otherUserId)/lastMessage" : lastMessage,
            "\(DBKey.ChatRooms)/\(myUserId)/\(otherUserId)/lastMessageDate" : lastMessageDate.fullDateString,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/lastMessage" : lastMessage,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/lastMessageDate" : lastMessageDate.fullDateString,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/chatRoomId" : chatRoomId,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserName" : myUserName,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserId" : myUserId
        ]


        try await db.updateChildValues(values)
    }
}
