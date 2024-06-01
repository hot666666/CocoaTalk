//
//  LoadingView.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/31/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.1)
            ProgressView()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingView()
}
