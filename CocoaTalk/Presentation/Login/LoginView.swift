//
//  LoginView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import SwiftUI

struct LoginIntroView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                
                VStack(spacing: 20){
                    Text("환영합니다.")
                        .font(.title)
                        .bold()
                    Text("무료 코코아톡을 부담없이 즐겨보세요!")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("로그인")
                        .bold()
                })
                .buttonStyle(LoginButtonStyle(textColor: .yellow))
                
            }
            .navigationDestination(isPresented: $isPresented) {
                LoginView()
            }
        }
    }
}

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    Text("로그인")
                        .font(.title)
                        .bold()
                    Text("아래 제공되는 서비스로 로그인 해주세요.")
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                Task {
                    await vm.send(action: .googleLogin)
                }
            }, label: {
                Text("Google로 로그인")
            })
            .buttonStyle(LoginButtonStyle(textColor: .black, borderColor: .gray))
        }
        .overlay {
            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                })
            }
        }
    }
}

#Preview("LoginIntro") {
    LoginIntroView()
}

#Preview("Login") {
    NavigationView {
        LoginView()
            .environmentObject(AuthenticationViewModel(container: .stub))
    }
}
