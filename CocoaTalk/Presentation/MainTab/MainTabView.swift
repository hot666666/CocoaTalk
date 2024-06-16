//
//  MainTabView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI

enum MainTabType: String, CaseIterable {
    case home = "친구"
    case chat = "채팅"
    case more = "더보기"
    
    var title: String {
        self.rawValue
    }
    
    func imageName(selected: Bool = false) -> String {
        switch self {
        case .home:
            return selected ? "person.fill" : "person"
        case .chat:
            return selected ? "message.fill" : "message"
        case .more:
            return "ellipsis"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(vm: .init(container: container, userId: authViewModel.userId!, selectedMainTab: $selectedTab))
                    case .chat:
                        ChatListView(vm: .init(container: container, userId: authViewModel.userId!))
                    case .more:
                        MoreView()
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.primary)
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.07)
    }
}

#Preview {
    let container: DIContainer = .stub
    let vm = AuthenticationViewModel(container: container)
    vm.userId = "loggedInUser"
    
    return MainTabView()
        .environmentObject(container)
        .environmentObject(vm)
}
