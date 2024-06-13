//
//  NavigationRoutingView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(chatRoomId, myUserId, otherUserId):
//            ChatView(viewModel: .init(container: container, chatRoomId: chatRoomId, myUserId: myUserId, otherUserId: otherUserId))
            Text("Chat")
                .toolbar(.hidden, for:.tabBar)
        case let .search(userId):
//            SearchView(viewModel: .init(container: container, userId: userId))
            Text("Search")
        }
    }
}
