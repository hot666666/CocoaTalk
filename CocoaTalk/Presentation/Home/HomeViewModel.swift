//
//  HomeViewModel.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    enum Action {
        case load
        case requestContacts
        case presentView(HomeModalDestination)
        case goToChat(User)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var loggedInUser: User?
    @Published var friends: [User] = []
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    
    private var selectedMainTab: Binding<MainTabType>
    private var container: DIContainer
    
    init(container: DIContainer, userId: String, selectedMainTab: Binding<MainTabType>) {
        self.container = container
        self.userId = userId
        self.selectedMainTab = selectedMainTab
    }
    
    @MainActor
    func send(action: Action) async {
        switch action {
        case .load:
            phase = .loading
            
            do {
                loggedInUser = try await container.services.userService.getUser(userId: userId)
                friends = try await container.services.userService.loadFriends(loggedInUser!)
            } catch {
                print(error)
                phase = .fail
                return
            }
            phase = .success
        case .requestContacts:
            print("gg")
        case .presentView(let homeModalDestination):
            modalDestination = homeModalDestination
        case .goToChat(let otherUser):
            if let chatRoom = try? await container.services.chatRoomService.createChatRoomIfNeeded(myUserId: loggedInUser!.id, otherUserId: otherUser.id, otherUserName: otherUser.name){
                withAnimation {
                    modalDestination = nil
                    selectedMainTab.wrappedValue = .chat
                    container.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId, myUserId: loggedInUser!.id, otherUserId: otherUser.id))
                }
            }
        }
    }
}
