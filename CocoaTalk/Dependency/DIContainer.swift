//
//  DIContainer.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubServices())
    }
}
