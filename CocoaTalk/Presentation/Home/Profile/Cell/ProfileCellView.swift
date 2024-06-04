//
//  ProfileCellView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import SwiftUI

struct MyProfileCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            URLImageView(urlString: user.profileURL, size: 28)
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 28))
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title2)
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
            URLImageView(urlString: user.profileURL, backgroundColor: .mint, size: 24)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
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
