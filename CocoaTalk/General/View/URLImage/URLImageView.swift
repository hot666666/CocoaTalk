//
//  URLImageView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import SwiftUI
import UIKit

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    let urlString: String?
    let backgroundColor: Color
    let size: CGFloat

    init(urlString: String? = nil, backgroundColor: Color = .teal, size: CGFloat = 40) {
        self.urlString = urlString
        self.backgroundColor = backgroundColor
        self.size = size
    }
    
    var body: some View {
        if let urlString = urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(container: container, urlString: urlString), size: size, backgroundColor: backgroundColor)
                .id(urlString)
        } else {
            DefaultBackgroundView(size: size, backgroundColor: backgroundColor)
        }
    }
}

fileprivate struct URLInnerImageView: View {
    @StateObject var viewModel: URLImageViewModel
    let size: CGFloat
    var backgroundColor: Color
    
    var body: some View {
        Group {
            if let loadedImage = viewModel.loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                DefaultBackgroundView(size: size, backgroundColor: backgroundColor)
            }
        }
        .onAppear {
            if !viewModel.loadingOrSuccess {
                viewModel.start()
            }
        }
    }
}

struct DefaultBackgroundView: View {
    let size: CGFloat
    var backgroundColor: Color
    
    var body: some View {
        backgroundColor
            .opacity(0.7)
            .overlay {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.secondary.opacity(0.5))
                    .frame(width: size, height: size)
            }
    }
}


#Preview {
    URLImageView()
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 40))
}
