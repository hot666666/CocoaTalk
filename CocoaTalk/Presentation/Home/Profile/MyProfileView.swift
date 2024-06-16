//
//  ProfileView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var container: DIContainer
    @StateObject var vm: MyProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.secondary
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // TODO: - 풀스크린 이미지 기능 추가
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 5)
                    
                    descriptionView
                    
                    menuView
                        .padding(.top, 120)
                        .padding(.bottom)
                }
                
                if vm.updateProfileText.isPresented {  /// Present TextField for update
                    MyProfileUpdateView(user: $vm.updateUser, profileText: vm.updateProfileText) {
                        vm.updateProfileText = .none
                    }
                }
            }
            .toolbar {
                if !vm.isEditMode && !vm.updateProfileText.isPresented {  /// ProfileView Toolbar
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                
                if vm.isEditMode && !vm.updateProfileText.isPresented {  /// EditMode Toolbar
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            vm.send(action: .removeEditMode)
                        } label: {
                            Text("취소")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            vm.send(action: .submitEditMode)
                        } label: {
                            Text("완료")
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .task {
                await vm.getUser()
            }
            .onDisappear {
                homeViewModel.loggedInUser = vm.user
            }
        }
    }
    
    var profileView: some View {
        EditablePhotoView(content:{
            URLImageView(urlString: vm.updateUser.profileURL)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 40))
        })
    }
    
    var nameView: some View {
        EditableTextView(content: {
            Text(vm.updateUser.name)
                .font(.title2)
        }){ 
            vm.updateProfileText = .name
        }
        
    }
    
    var descriptionView: some View {
        EditableTextView(content: {
            Text(vm.updateUser.description ?? vm.defualtUserDescription)
        }){
            vm.updateProfileText = .description
        }
    }
    
    var menuView: some View {
        VStack{
            Rectangle()
                .frame(height: 0.5)
                .padding(.bottom)
                .opacity(vm.isEditMode ? 0 : 1)
            if vm.isEditMode {
                editModeMenuView
            } else {
                defaultMenuView
            }
        }
        .frame(height: 50)
    }
    
    var defaultMenuView: some View {
        HStack(alignment: .bottom, spacing: 27) {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack(spacing: 10) {
                    Image(systemName: "message.fill")
                        .font(.title3)
                        .bold()
                    Text("나와의 채팅")
                }
            })
            Button(action: {
                vm.send(action: .enableEditMode)
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "pencil")
                        .font(.title3)
                        .bold()
                    Text("프로필 편집")
                }
            })
        }
    }
    
    var editModeMenuView: some View {
        Button(action: {}, label: {
             VStack(spacing: 10){
                 Image(systemName: "photo")
                     .font(.title3)
                     .bold()
                 Text("배경 업로드")
             }
         })
    }
}
extension MyProfileView {
    func EditableTextView(@ViewBuilder content: @escaping () -> Text, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            content()
                .bold()
                .padding(.bottom, 5)
            Rectangle()
                .frame(height: 0.5)
                .opacity(vm.isEditMode ? 1 : 0)
        }
        .overlay(alignment: .trailing){
            Button(action: {
                action()
            }, label: {
                Image(systemName: "pencil")
            })
            .opacity(vm.isEditMode ? 1 : 0)
        }
        .padding(.horizontal, 20)
    }
    
    func EditablePhotoView(@ViewBuilder content: @escaping () -> some View) -> some View {
        content()
            .overlay(alignment: .bottomTrailing){
                if vm.isEditMode {
                    PhotosPicker(selection: $vm.imageSelection, matching: .images){
                        Image(systemName: "camera.circle.fill")
                            .font(.title)
                            .background(Color.secondary)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
    }
}

#Preview {
    MyProfileView(vm: .init(container: .stub, user: .stubUser))
}
