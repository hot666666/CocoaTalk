//
//  MyProfileUpdateView.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import SwiftUI

struct MyProfileUpdateView: View {
    @FocusState var isFocused: Bool
    @State var tempText: String
    var user: Binding<User>
    var profileText: UpdateProfileText
    var action: () -> Void
    
    init?(user: Binding<User>, profileText: UpdateProfileText, action: @escaping () -> Void){
        self.user = user
        self.profileText = profileText
        self.action = action
        
        switch profileText {
        case .name:
            self._tempText = State(wrappedValue: user.wrappedValue.name)
        case .description:
            self._tempText = State(wrappedValue: user.wrappedValue.description ?? "")
        case .none:
            return nil
        }
    }
    
    var disabled: Bool {
        let text = switch profileText {
        case .name:
            user.name.wrappedValue
        case .description:
            user.description.wrappedValue
        case .none:
            ""
        }
        return tempText.isEmpty || (text == tempText)
    }
    
    func update() {
        switch profileText {
        case .name:
            user.wrappedValue.name = tempText
        case .description:
            user.wrappedValue.description = tempText
        case .none:
            break
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(alignment: .center){
                TextField("", text: $tempText)
                    .focused($isFocused)
                Rectangle()
                    .frame(height: 0.5)
            }
            .overlay(alignment: .trailing){
                Button(action: {
                    tempText = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                })
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                    action()
                }, label: {
                    Text("취소")
                })
            })
            ToolbarItem(placement: .principal, content: {
                Text(profileText.rawValue)
                    .bold()
            })
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    update()
                    action()
                }, label: {
                    Text("확인")
                })
                .disabled(disabled)
                .opacity(disabled ? 0.5 : 1)
            })
        }
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        MyProfileUpdateView(user: .constant(.stubUser), profileText: .name, action: {})
            .foregroundColor(.white)
    }
}
