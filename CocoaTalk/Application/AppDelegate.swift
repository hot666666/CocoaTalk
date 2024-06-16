//
//  AppDelegate.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if !ProcessInfo.processInfo.environment.keys.contains("XCODE_RUNNING_FOR_PREVIEWS") {  /// xcode16 preview 오류
            FirebaseApp.configure()
        }
        return true
    }
}
