//
//  HomeViewModel.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation

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
    
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
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
        case .goToChat(let user):
            print("gg")
        }
    }
}
