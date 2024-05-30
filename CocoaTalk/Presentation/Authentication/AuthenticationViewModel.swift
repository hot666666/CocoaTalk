//
//  AuthenticationViewModel.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

enum AuthenticationState {
    case authenticated
    case unauthenticated
}

class AuthenticationViewModel: ObservableObject {
    enum Action {
        case googleLogin
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    var userId: String?
    
    private var container: DIContainer
    init(container: DIContainer) {
        self.container = container
    }
    
    @MainActor
    func send(action: Action) async {
        switch action {
        case .googleLogin:
            isLoading = true
            
            if let user = try? await container.services.authService.signInWithGoogle() {
                userId = user.id
                authenticationState = .authenticated
            }
            
            isLoading = false
        }
    }
}
