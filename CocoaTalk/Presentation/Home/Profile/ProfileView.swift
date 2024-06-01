//
//  ProfileView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    let user: User
    var isMine: Bool = true
    
    var body: some View {
        ZStack{
            // MARK: - fullProfileURL
            Color.secondary
                .ignoresSafeArea()
            
            VStack{
                headerView
                
                Spacer()
                
                VStack{
                    ProfileImageView(viewType: .profileView, profileURL: user.profileURL)
                    Text(user.name)
                        .font(.title)
                    Text(user.description ?? "")
                }
                .padding(100)
                
                Rectangle()
                    .frame(height: 0.5)
                
                HStack(spacing: 35){
                    bottomView
                    
                }
                .padding()
            }
        }
        .foregroundColor(.white)
    }
    
    var headerView: some View {
        HStack{
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title3)
            })
            .padding()
            Spacer()
        }
    }
    
    @ViewBuilder
    var bottomView: some View {
        if isMine {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack(spacing: 10) {
                    Image(systemName: "message.fill")
                        .font(.title3)
                        .bold()
                    Text("나와의 채팅")
                }
            })
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack(spacing: 10) {
                    Image(systemName: "pencil")
                        .font(.title3)
                        .bold()
                    Text("프로필 편집")
                }
            })
        } else {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack(spacing: 10) {
                    Image(systemName: "message.fill")
                        .font(.title3)
                        .bold()
                    Text("1:1 채팅")
                }
            })
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.title3)
                        .bold()
                    Text("통화하기")
                }
            })
        }
    }
}
#Preview {
    let user: User = .init(id: "user_id", name: "치히로")
    return ProfileView(user: user)
}
