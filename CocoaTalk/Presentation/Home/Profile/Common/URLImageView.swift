//
//  URLImageView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import SwiftUI

func defaultBackground() -> Color {
    let colors: [Color] = [.indigo, .mint, .purple, .teal]
    return colors.randomElement()!
}

struct URLImageView: View {
    let urlString: String?
    let size: CGFloat
    
    init(urlString: String? = nil, size: CGFloat = 40) {  /// frame 100 : size 40
        self.urlString = urlString
        self.size = size
    }
    
    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { image in
            image.resizable()
        } placeholder: {
            defaultBackground()
                .opacity(0.7)
                .overlay {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(.secondary.opacity(0.5))
                        .frame(width: size, height: size)
                }
        }

    }
}

#Preview {
    URLImageView()
}
