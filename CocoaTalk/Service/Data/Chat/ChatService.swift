//
//  ChatService.swift
//  CocoaTalk
//
//  Created by hs on 6/14/24.
//

import Foundation
import Combine
 
protocol ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) async throws
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never>
    func removeObservedHandlers()
}

class ChatService: ChatServiceType {
    
    private let dbRepository: ChatDBRepositoryType
    
    init(dbRepository: ChatDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func addChat(_ chat: Chat, to chatRoomId: String) async throws {
        var chat = chat
        /// 만들어질 Chat의 Id를 얻어 .chatId에 적용
        chat.chatId = dbRepository.childByAutoId(chatRoomId: chatRoomId)
        
        do {
            try await dbRepository.addChat(chat.toObject(), to: chatRoomId)
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        dbRepository.observeChat(chatRoomId: chatRoomId)
            .map { $0?.toModel() }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        dbRepository.removeObservedHandlers()
    }
}

class StubChatService: ChatServiceType {

    func addChat(_ chat: Chat, to chatRoomId: String) async throws {
        
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        Just(.stub).eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {

    }
}
