//
//  ChatListView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import SwiftUI

class ChatListViewModel: ObservableObject {
    enum Action {
        case load
    }
    
    private var container: DIContainer
    let userId: String
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    @Published var chatRooms: [ChatRoom] = []
    
    @MainActor
    func send(action: Action) async {
        switch action {
        case .load:
            if let chatRooms = try? await container.services.chatRoomService.loadChatRooms(myUserId: userId){
                self.chatRooms = chatRooms
            }
        }
    }
}

struct ChatListView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var vm: ChatListViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            header
            
            ScrollView {
                ForEach(vm.chatRooms, id: \.self) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, myUserId: vm.userId)
                        .padding(.top, 10)
                }
            }
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
            .task {
                await vm.send(action: .load)
            }
        }
    }
    
    @ViewBuilder
    var header: some View {
        HStack{
            Text("채팅")
                .bold()
                .font(.title)
            
            Spacer()
            
            HStack {
                // TODO: - SearchBar
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName:"magnifyingglass")
                })
                Button(action: {}, label: {
                    Image(systemName:"plus.message")
                    
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName:"gearshape")
                })
            }
            .foregroundColor(.primary)
            
        }
        .padding(.horizontal)
        Divider()
    }
}

fileprivate struct ChatRoomCell: View {
    @EnvironmentObject var container: DIContainer
    let chatRoom: ChatRoom
    let myUserId: String
    @State var otherUserProfile: String? = nil
    
    var body: some View {
        NavigationLink(value: NavigationDestination.chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: myUserId,
                                                         otherUserId: chatRoom.otherUserId)) {
            HStack(spacing: 8) {
                URLImageView(urlString: otherUserProfile, backgroundColor: .mint, size: 24)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                VStack(alignment: .leading, spacing: 3) {
                    Text(chatRoom.otherUserName)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Text(chatRoom.lastMessageDate?.monthAndDay ?? " ")
                    .foregroundColor(.secondary)
            }
            .task {
                if let otherUser = try? await container.services.userService.getUser(userId: chatRoom.otherUserId){
                    otherUserProfile = otherUser.profileURL
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    ChatListView(vm: .init(container: DIContainer.stub, userId: "user_id"))
        .environmentObject(DIContainer.stub)
}
