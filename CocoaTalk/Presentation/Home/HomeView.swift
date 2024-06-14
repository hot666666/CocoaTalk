//
//  HomeView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI

enum Phase {
    case notRequested
    case loading
    case success
    case fail
}

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(User)
    
    var id: Int { hashValue }
}

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: HomeViewModel
    @EnvironmentObject var container: DIContainer

    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            contentView
                .fullScreenCover(item: $vm.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView(vm: .init(container: container, user: vm.loggedInUser!))
                            .environmentObject(vm)
                    case let .otherProfile(friend):
                        OtherProfileView(otherUser: friend) { otherUser in
                            await vm.send(action: .goToChat(otherUser))
                        }
                    }
                }
                .navigationDestination(for: NavigationDestination.self) {
                    NavigationRoutingView(destination: $0)
                }
        }
    }
    
    // MARK: - Remember this pattern
    @ViewBuilder
    var contentView: some View {
        switch vm.phase {
        case .notRequested:
            /// Placeholder View
            ((colorScheme == .dark) ? Color.black : Color.white)
                .task {
                    await vm.send(action: .load)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
                .sheet(isPresented: $vm.isPresentedAddFriendView, content: {
                    VStack{
                        TextField("", text: $vm.addFriendId)
                            .padding()
                            .onSubmit {
                                Task {
                                    await vm.send(action: .addFriend)
                                }
                            }
                            .border(Color.secondary, width: 1)
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("친구")
                            .bold()
                            .font(.title)
                    }
                    
                    // TODO: - HomeView 상단바 구현
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack{
                            Button {
                                
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            Button {
                                vm.isPresentedAddFriendView.toggle()
                            } label: {
                                Image(systemName: "person.badge.plus")
                            }
                            Button {
                                
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
        case .fail:
            // TODO: - fail 뷰
            Text("오류")
        }
    }
    
    var loadedView: some View {
        ScrollView {
            Button(action: {
                Task {
                    await vm.send(action: .presentView(.myProfile))
                }
            }, label: {
                MyProfileCellView(user: vm.loggedInUser!)
            })
            .padding()
            
            // TODO: - 접히기/펼치기
            VStack(alignment: .leading){
                Divider()
                HStack{
                    Text("친구 \(vm.friends.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            // TODO: - 친구 0명일 때, 추가 방식 추가
            LazyVStack{
                ForEach(vm.friends, id: \.self){ friend in
                    Button(action: {
                        Task{
                            await vm.send(action: .presentView(.otherProfile(friend)))
                        }
                    }, label: {
                        OtherProfileCellView(user: friend)
                    })
                }
                .padding(.horizontal)
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    let container: DIContainer = .stub
    let user: User = .stubUser
    let vm: HomeViewModel = .init(container: container, userId: user.id, selectedMainTab: .constant(MainTabType.home))
    vm.loggedInUser = user
    
    return HomeView(vm: vm).environmentObject(container)
}
