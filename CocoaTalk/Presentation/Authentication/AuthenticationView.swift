//
//  AuthenticationView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var vm: AuthenticationViewModel
    
    var body: some View {
        switch vm.authenticationState {
        case .authenticated:
            MainTabView()
                .environmentObject(vm)
                .environment(\.managedObjectContext, container.searchDataController.persistantContainer.viewContext)
                .preferredColorScheme(container.appearanceController.appearance.colorScheme)
        case .unauthenticated:
            LoginIntroView()
                .environmentObject(vm)
                .preferredColorScheme(container.appearanceController.appearance.colorScheme)
        }
        
    }
}

#Preview {
    AuthenticationView(vm: AuthenticationViewModel(container: .stub))
        .environmentObject(DIContainer.stub)
}
