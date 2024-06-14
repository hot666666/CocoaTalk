//
//  ChatView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/12/24.
//

import SwiftUI

struct ChatRoomView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var vm: ChatViewModel
    @FocusState private var isFocused: Bool
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        if vm.chatDataList.isEmpty {
                            Text("아직 대화기록이 없습니다.")
                        } else {
                            content
                        }
                    }
                    .padding(.top, 100)
                    .onChange(of: vm.chatDataList.last) { newValue in
                        if let lastChat = newValue {
                            proxy.scrollTo(lastChat.id, anchor: .bottom)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                header
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
            .keyboardToolbar(height: 50) {
                ChatKeyboardView(text: $vm.sendMessage, action: {
                    Task {
                        await vm.send(action: .sendMessage)
                    }
                })
                .focused($isFocused)
                .padding(.horizontal, 10)
            }
        }
        .task {
            await vm.send(action: .load)
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Button(action: {
                    Task {
                        await vm.send(action: .pop)
                    }
                }) {
                    Image(systemName: "chevron.backward")
                }
                
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .overlay {
                Text(vm.otherUser?.name ?? "")
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background((isDarkMode ? Color.black : Color.white).opacity(0.5))
            .foregroundColor(isDarkMode ? .white : .black)
            .bold()
            .font(.title3)
            
            Spacer()
        }
    }
    
    private var content: some View {
        LazyVStack {
            ForEach(vm.chatDataList, id: \.self) { item in
                ChatsByDateView(chatData: item)
            }
        }
        .padding(10)
        .environmentObject(vm)
    }
}

#Preview {
    ChatRoomView(vm: .init(container: .stub, chatRoomId: "채팅방1", userId: "나", otherUserId: "윤지디"))
}
