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
            Text("인증됨")
        case .unauthenticated:
            LoginIntroView()
                .environmentObject(vm)
        }
    }
}

#Preview {
    AuthenticationView(vm: AuthenticationViewModel(container: .stub))
}
