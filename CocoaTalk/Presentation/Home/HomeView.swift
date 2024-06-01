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
    @StateObject var vm: HomeViewModel

    var body: some View {
        NavigationStack {
            contentView
                .fullScreenCover(item: $vm.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        ProfileView(user: vm.loggedInUser!)
                    case let .otherProfile(friend):
                        ProfileView(user: friend, isMine: false)
                    }
                }
        }
    }
    
    // MARK: - Remember this pattern
    @ViewBuilder
    var contentView: some View {
        switch vm.phase {
        case .notRequested:
            // Placeholder View
            Color.white
                .task {
                    await vm.send(action: .load)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("친구")
                            .bold()
                            .font(.title)
                    }
                    
                    // TODO: - HomeView 상단바
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack{
                            Button {
                                
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            Button {
                                
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
            
            // TODO: - 친구 0명일 때, 추가 방식
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
    HomeView(vm: .init(container: .stub, userId: "loggedInUser"))
}
