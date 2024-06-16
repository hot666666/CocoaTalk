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
    @AppStorage(AppStorageType.Appearance) var appearanceValue: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    @StateObject var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(vm: .init(container: container))
                .environmentObject(container)
                .onAppear {
                    container.appearanceController.changeAppearance(AppearanceType(rawValue: appearanceValue))
                }
        }
    }
}
