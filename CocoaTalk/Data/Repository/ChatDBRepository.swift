//
//  ChatDBRepository.swift
//  CocoaTalk
//
//  Created by hs on 6/14/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatDBRepositoryType {
    func addChat(_ object: ChatObject, to chatRoomId: String) async throws
    func childByAutoId(chatRoomId: String) -> String
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func removeObservedHandlers()
}

class ChatDBRepository: ChatDBRepositoryType {
    
    private let reference: DBReferenceType
    
    init(reference: DBReferenceType = DBReference()) {
        self.reference = reference
    }
    
    func addChat(_ object: ChatObject, to chatRoomId: String) async throws {
        guard
            let data = try? JSONEncoder().encode(object),
            /// Firebase Database는 NSNumber, NSString, NSDictionary, NSArray 타입의 객체만 저장가능
            /// 따라서 인코딩된 Data 객체를 NSDictionary나 NSArray로 변환해야함
            let jsonEncodedChat = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        else {
            throw DBRepositoryError.encodingError
        }
        
        do {
            try await self.reference.setValue(key: DBKey.Chats, path: "\(chatRoomId)/\(object.chatId)", value: jsonEncodedChat)
        } catch {
            throw DBRepositoryError.setValueError
        }
    }
    
    func childByAutoId(chatRoomId: String) -> String {
        reference.childByAutoId(key: DBKey.Chats, path: chatRoomId) ?? ""
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        reference.observeChildAdded(key: DBKey.Chats, path: chatRoomId)
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatObject?.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        reference.removeObservedHandlers()
    }
}
