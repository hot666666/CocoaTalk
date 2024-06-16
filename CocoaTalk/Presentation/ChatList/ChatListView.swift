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
            ScrollView {
                ForEach(vm.chatRooms, id: \.self) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, myUserId: vm.userId)
                        .padding(.top, 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("채팅")
                        .bold()
                        .font(.title)
                        .frame(height: 60)
                }
                
                // TODO: - ChatListView 상단바 구현
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName:"magnifyingglass")
                                .frame(width: 24, height: 24)
                        })
                        Button(action: {}, label: {
                            Image(systemName:"plus.message")
                                .frame(width: 24, height: 24)
                            
                        })
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName:"gearshape")
                                .frame(width: 24, height: 24)
                        })
                    }
                    .frame(height: 44)
                    .foregroundColor(.primary)
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
}

fileprivate struct ChatRoomCell: View {
    @EnvironmentObject var container: DIContainer
    let chatRoom: ChatRoom
    let myUserId: String
    @State var otherUserProfile: String? = nil
    
    var body: some View {
        Button(action: {
            container.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId, myUserId: myUserId, otherUserId: chatRoom.otherUserId))
        }, label: {
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
            .padding(.horizontal)
            .padding(.bottom, 10)
        })
        .task {
            if let otherUser = try? await container.services.userService.getUser(userId: chatRoom.otherUserId){
                otherUserProfile = otherUser.profileURL
            }
        }
    }
}


#Preview {
    ChatListView(vm: .init(container: DIContainer.stub, userId: "user_id"))
        .environmentObject(DIContainer.stub)
}
