//
//  ProfileCellView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI

func defaultBackground() -> Color {
    let colors: [Color] = [.indigo, .mint, .purple, .teal]
    return colors.randomElement()!
}

enum ProfileImageViewType: CGFloat {
    case myProfileCellView = 12
    case otherProfileCellView = 10
    case profileView = 20
}

struct ProfileImageView: View {
    var viewType: ProfileImageViewType = .myProfileCellView
    var profileURL: String? = nil

    private var frameSize: CGFloat { viewType.rawValue*5 }
    private var imageSize: CGFloat { viewType.rawValue*2 }
    
    var body: some View {
        AsyncImage(url: URL(string: profileURL ?? "")) { phase in
            if let image = phase.image {
                image.resizable()
            } else {
                defaultBackground()
                    .opacity(0.7)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(.secondary.opacity(0.5))
                            .frame(width: imageSize, height: imageSize)
                    }
            }
        }
        .frame(width: frameSize, height: frameSize)
        .clipShape(RoundedRectangle(cornerRadius: imageSize))
    }
}

struct MyProfileCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            ProfileImageView(viewType: .myProfileCellView, profileURL: user.profileURL)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title3)
                    .bold()
                if let description = user.description {
                    Text(description)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}

struct OtherProfileCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            ProfileImageView(viewType: .otherProfileCellView, profileURL: user.profileURL)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title3)
                if let description = user.description {
                    Text(description)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}

#Preview("MyProfile CellView") {
    let user1: User = .init(id: "user_id1", name: "이름임", profileURL: "https://avatars.githubusercontent.com/u/73470656?v=4", description: "설명")
    let user2: User = .init(id: "user_id2", name: "이름임", profileURL: nil, description: "설명")
    return VStack{
        MyProfileCellView(user: user1)
        MyProfileCellView(user: user2)
    }
}

#Preview("OtherProfile CellView") {
    let user1: User = .init(id: "user_id1", name: "이름임", profileURL: "https://avatars.githubusercontent.com/u/73470656?v=4", description: "안녕, 세상")
    let user2: User = .init(id: "user_id2", name: "이름임", profileURL: nil, description: "안녕, 세상")
    return VStack{
        OtherProfileCellView(user: user1)
        OtherProfileCellView(user: user2)
    }
}
