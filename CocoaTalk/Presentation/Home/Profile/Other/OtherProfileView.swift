//
//  OtherProfileView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    let otherUser: User
    var goToChat: (User) async -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.secondary
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 5)
                    
                    descriptionView
                    
                    menuView
                        .padding(.top, 120)
                        .padding(.bottom)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .foregroundColor(.white)
        }
    }
    
    var profileView: some View {
        URLImageView(urlString: otherUser.profileURL, backgroundColor: .mint)
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 40))
    }
    
    var nameView: some View {
        Text(otherUser.name)
            .font(.title2)
        
    }
    
    var descriptionView: some View {
        Text(otherUser.description ?? " ")
    }
    
    var menuView: some View {
        VStack{
            Rectangle()
                .frame(height: 0.5)
                .padding(.bottom)
            defaultMenuView
        }
        .frame(height: 50)
    }
    
    var defaultMenuView: some View {
        HStack(alignment: .bottom, spacing: 27) {
            Button(action: {
                Task {
                    await goToChat(otherUser)
                }
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "message.fill")
                        .font(.title3)
                        .bold()
                    Text("1:1 채팅")
                }
            })
            Button(action: {
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.title3)
                        .bold()
                    Text("보이스톡")
                }
            })
        }
    }
}

#Preview {
    OtherProfileView(otherUser: User.stubUsers[0]){ _ in
        
    }
}
