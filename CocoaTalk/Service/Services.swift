//
//  Services.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    
    init(
        authService: AuthenticationServiceType = AuthenticationService(),
        userService: UserServiceType = UserService(dbRepository: UserDBRepository())
    ) {
        self.authService = authService
        self.userService = userService
    }
}

class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
}
