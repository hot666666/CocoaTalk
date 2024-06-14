//
//  ChatRoomViewModel.swift
//  CocoaTalk
//
//  Created by hs on 6/14/24.
//

import Combine
import Foundation

class ChatViewModel: ObservableObject {
    enum Action {
        case sendMessage
        case load
        case pop
    }
    
    @Published var chatDataList = [ChatData]()
    @Published var myUser: User?
    @Published var otherUser: User?
    @Published var sendMessage: String = ""
    
    private let chatRoomId: String
    private let userId: String
    private let otherUserId: String
    private var subscriptions = Set<AnyCancellable>()
    private let container: DIContainer
    
    init(container: DIContainer, chatRoomId: String, userId: String, otherUserId: String) {
        self.container = container
        self.chatRoomId = chatRoomId
        self.otherUserId = otherUserId
        self.userId = userId
        
        bind()
    }
    
    func bind() {
        container.services.chatService.observeChat(chatRoomId: chatRoomId)
            .sink { [weak self] chat in
                guard let chat else {return }
                self?.updateChatDataList(chat)
            }.store(in: &subscriptions)
    }
    
    func updateChatDataList(_ chat: Chat) {
        let key = chat.date.YMDEString
        
        if let index = chatDataList.firstIndex(where: { $0.dateStr == key }) {
            chatDataList[index].chats.append(chat)
        } else {
            let newChatData: ChatData = .init(dateStr: key, chats: [chat])
            chatDataList.append(newChatData)
        }
    }
    
    func isMine(id: String) -> Bool {
        userId == id
    }
    
    @MainActor
    func send(action: Action) async {
        switch action {
        case .sendMessage:
            let newMessage: Chat = .init(chatId: UUID().uuidString, userId: userId, message: sendMessage, photoURL: nil, date: .now)
            do {
                try await container.services.chatService.addChat(newMessage, to: chatRoomId)
                try await container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: chatRoomId, myUserId: userId, myUserName: myUser!.name, otherUserId: otherUserId, lastMessage: sendMessage, lastMessageDate: .now)
            } catch {
                
            }
            sendMessage = ""
        case .load:
            async let myUser = container.services.userService.getUser(userId: userId)
            async let otherUser = container.services.userService.getUser(userId: otherUserId)
            
            do {
                self.myUser = try await myUser
                self.otherUser = try await otherUser
            } catch {
                
            }
            
        case .pop:
            container.navigationRouter.pop()
        }
    }
}
