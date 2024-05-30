//
//  CocoaTalkApp.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import SwiftUI

@main
struct CocoaTalkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(vm: .init(container: container))
                .environmentObject(container)
        }
    }
}
