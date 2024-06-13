//
//  ChatView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/12/24.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
}

struct ChatView: View {
    @StateObject var vm: ChatViewModel
    
    var body: some View {
        ScrollView{
            
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){
                Button(action: {
                    // TODO : - 뒤로가기
                }, label: {
                    Image(systemName: "chevron.left")
                })
                Text("대화방이름")
                    .font(.title3)
                    .bold()
            }
        }
    }
}

struct ChatDateTimeView: View {
    var body: some View {
        Capsule()
            .overlay{
                Text(Date.now.YMDDateString)
            }
    }
}

#Preview {
    ChatView(vm: .init())
}
