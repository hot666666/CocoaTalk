//
//  AuthenticationService.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum AuthenticationError: Error {
    case clientIdError
    case windowSceneError
    case GIDSignInError
    case tokenError
    case firebaseAuthenticationError
    case logoutError
}

protocol AuthenticationServiceType {
    func signInWithGoogle() async throws -> User
    func logout() async throws
}

class AuthenticationService: AuthenticationServiceType {
    @MainActor
    func signInWithGoogle() async throws -> User {
     /// 1. FirebaseApp clientID를 얻어 GIDSignIn의 설정
     /// 2. Scene을 GIDSignIn.sharedInstance에 전달하여 로그인을 진행
     /// 3. token과 accessToken을 얻으면,GoogleAuthProvider로 AuthCredential을 생성
     /// 4. AuthCredential을 가지고 authenticateUserWithFirebase 수행
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationError.clientIdError
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,  /// UIApplication.shared.connectedScenes.first로 Secene을 얻을 수 있는데
              let window = windowScene.windows.first,                                          /// 이 과정은 MainThread에서 이루어져야 하기에 @MainActor 사용
              let rootViewController = window.rootViewController else {
            throw AuthenticationError.windowSceneError
        }
        
        guard let result = try? await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) else {
            throw AuthenticationError.GIDSignInError
        }
        
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw AuthenticationError.tokenError
        }
        
        let accessToken = user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return try await authenticateUserWithFirebase(credential: credential)
    }
    
    func logout() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthenticationError.logoutError
        }
    }
}

extension AuthenticationService {
    private func authenticateUserWithFirebase(credential: AuthCredential) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = result.user
            let user: User = .init(id: firebaseUser.uid,
                                   name: firebaseUser.displayName ?? "",
                                   phoneNumber: firebaseUser.phoneNumber,
                                   profileURL: firebaseUser.photoURL?.absoluteString)
            return user
        } catch {
            throw AuthenticationError.firebaseAuthenticationError
        }
    }
}

class StubAuthenticationService: AuthenticationServiceType {
    func signInWithGoogle() async throws -> User {
        return User(id: "", name: "")
    }
    
    func logout() async throws {
        
    }
}
