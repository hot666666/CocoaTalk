//
//  ChatRoomService.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

protocol ChatRoomServiceType {
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) async throws -> ChatRoom
    func loadChatRooms(myUserId: String) async throws -> [ChatRoom]
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String, lastMessageDate: Date) async throws
}

class ChatRoomService: ChatRoomServiceType {
    
    private let dbRepository: ChatRoomDBRepositoryType
    
    init(dbRepository: ChatRoomDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) async throws -> ChatRoom {
        do {
            if let object = try? await dbRepository.getChatRoom(myUserId: myUserId, otherUserId: otherUserId) {
                return object.toModel()
            } else {
                let newChatRoom: ChatRoom = .init(chatRoomId: UUID().uuidString, otherUserName: otherUserName, otherUserId: otherUserId)
                try await dbRepository.addChatRoom(newChatRoom.toObject(), myUserId: myUserId)
                return newChatRoom
            }
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func loadChatRooms(myUserId: String) async throws -> [ChatRoom] {
        do {
            let objects = try await dbRepository.loadChatRooms(myUserId: myUserId)
            return objects.map { $0.toModel() }
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String, lastMessageDate: Date) async throws {
        do {
            try await dbRepository.updateChatRoomLastMessage(chatRoomId: chatRoomId, myUserId: myUserId, myUserName: myUserName, otherUserId: otherUserId, lastMessage: lastMessage, lastMessageDate: lastMessageDate)
        } catch {
            throw ServiceError.error(error)
        }
    }
}

class StubChatRoomService: ChatRoomServiceType {
    func loadChatRooms(myUserId: String) async throws -> [ChatRoom] {
        [.stub1, .stub2]
    }
    
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) async throws -> ChatRoom {
        .stub1
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String, lastMessageDate: Date) async throws {
        
    }
}
