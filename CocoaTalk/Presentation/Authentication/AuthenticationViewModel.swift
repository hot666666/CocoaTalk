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
        case logout
    }
    
    @Published var isLoading: Bool = false
    // MARK: - fast login
    @Published var authenticationState: AuthenticationState = .authenticated
    var userId: String? = "OomlQWpxfYNXxlbVU40JsA5jdz82"
    
    private var container: DIContainer
    init(container: DIContainer) {
        self.container = container
    }
    
    @MainActor
    func send(action: Action) async {
        switch action {
        case .googleLogin:
            isLoading = true
            defer { isLoading = false }
            
            do {
                let googleUser = try await container.services.authService.signInWithGoogle()
                let user = try await container.services.userService.loginUser(googleUser)
                userId = user.id
                authenticationState = .authenticated
            } catch {
                print(error)
            }
            
        case .logout:
            defer {
                authenticationState = .unauthenticated
                userId = nil
            }
            
            do {
                try await container.services.authService.logout()
            } catch {
                print(error)
            }
        }
    }
}
