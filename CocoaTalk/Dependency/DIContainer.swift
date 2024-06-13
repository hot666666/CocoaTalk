//
//  DIContainer.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    
    init(services: ServiceType,
         navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter()) {
        self.services = services
        self.navigationRouter = navigationRouter
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubServices())
    }
}
