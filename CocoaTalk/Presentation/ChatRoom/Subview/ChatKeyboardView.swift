//
//  ChatKeyboardView.swift
//  CocoaTalk
//
//  Created by hs on 6/13/24.
//

import SwiftUI

struct ChatKeyboardView: View {
    @Binding var text: String
    var action: () async -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
            
            TextField("", text: $text)
                .onSubmit {
                    Task {
                        await action()
                    }
                }
                .offset(x: 5)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 40))
                .overlay {
                    HStack {
                        Spacer()
                        Button(action: {
                                Task {
                                    await action()
                                }
                        }, label: {
                            if text.isEmpty {
                                Image(systemName: "number")
                            } else {
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.yellow)
                            }
                        })
                    }
                    .padding(10)
                }
        }
        .foregroundColor(.secondary)
        .font(.title2)
    }
}

struct ChatKeyboardView_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        ChatKeyboardView(text: $text, action: { })
    }
}
