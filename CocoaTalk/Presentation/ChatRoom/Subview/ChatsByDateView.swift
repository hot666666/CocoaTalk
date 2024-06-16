//
//  ChatsByDateView.swift
//  CocoaTalk
//
//  Created by hs on 6/13/24.
//

import SwiftUI

struct ChatsByDateView: View {
    @EnvironmentObject var vm: ChatViewModel
    let chatData: ChatData
    
    var body: some View {
        dateView
            .padding()
        ForEach(chatData.chats) { chat in
            HStack(alignment: .top, spacing: 10) {
                if vm.isMine(id: chat.userId) {
                    MyMessageView(chat: chat)
                } else {
                    OtherMessageView(chat: chat)
                }
            }
            .id(chat.id)
        }
    }
    
    var dateView: some View {
        HStack {
            Text(Image(systemName: "calendar")) + Text(chatData.dateStr) + Text(Image(systemName: "chevron.right"))
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color.secondary))
    }
}

struct MyMessageView: View {
    let chat: Chat
    
    var body: some View {
        Spacer()
        MessageView(chat: chat, isMine: true)
    }
}

struct OtherMessageView: View {
    @EnvironmentObject var vm: ChatViewModel
    let chat: Chat
    
    var body: some View {
        URLImageView(urlString: vm.otherUser?.profileURL, backgroundColor: .mint, size: 20)
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        
        VStack(alignment: .leading, spacing: 5) {
            Text(vm.otherUser?.name ?? "이름없음")
                .foregroundColor(.secondary)
                .bold()
            
            MessageView(chat: chat, isMine: false)
        }
        Spacer()
    }
}

struct MessageView: View {
    let chat: Chat
    let isMine: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            if isMine {
                messageTime
            }
            
            Text(chat.message ?? "")
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 15)
                    .fill(isMine ? Color.yellow : Color.gray))
                .foregroundColor(isMine ? .primary : .white)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
            
            if !isMine {
                messageTime
            }
        }
    }
    
    private var messageTime: some View {
        Text(chat.date.AHMDateString)
            .foregroundColor(.secondary)
            .font(.footnote)
    }
}
