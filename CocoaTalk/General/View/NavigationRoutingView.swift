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
        case let .chat(chatRoomId, userId, otherUserId):
            ChatRoomView(vm: .init(container: container, chatRoomId: chatRoomId, userId: userId, otherUserId: otherUserId))
                .toolbar(.hidden, for:.tabBar)
        case let .search(userId):
            SearchView(vm: .init(container: container, userId: userId))
        }
    }
}
