//
//  Services.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

enum ServiceError: Error {
    case error(Error)
}

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    
    init(authService: AuthenticationServiceType = AuthenticationService()) {
        self.authService = authService
    }
}

class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}
