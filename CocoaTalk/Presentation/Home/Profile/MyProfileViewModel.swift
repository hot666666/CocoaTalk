//
//  MyProfileViewModel.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import Foundation
import PhotosUI
import SwiftUI

enum UpdateProfileText: String {
    case name = "이름"
    case description = "상태메시지"
    case none
    
    var isPresented: Bool {
        !(self == .none)
    }
}

@MainActor
class MyProfileViewModel: ObservableObject {
    enum Action {
        case enableEditMode
        case removeEditMode
        case submitEditMode
    }
    
    var user: User
    @Published var updateUser: User
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateTempProfileImage(pickerItem: imageSelection)
            }
        }
    }
    @Published var isEditMode: Bool = false
    @Published var updateProfileText: UpdateProfileText = .none
    
    let userId: String
    private let container: DIContainer
    
    init(container: DIContainer, user: User) {
        self.container = container
        self.user = user
        self.updateUser = user
        self.userId = user.id
    }
    
    func send(action: Action){
        switch action {
        case .enableEditMode:
            isEditMode = true
        case .removeEditMode:
            updateUser = user
            imageSelection = nil
            isEditMode = false
        case .submitEditMode:
            updateProfileSubmit()
            user = updateUser
            isEditMode = false
        }
    }
}

extension MyProfileViewModel {
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            self.user = user
            updateUser = user
        }
    }
    
    func updateTempProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            let fileName = UUID().uuidString
            container.services.imageCacheService.store(for: fileName, image: UIImage(data: data)!, toDisk: false)
            updateUser.profileURL = fileName
        } catch {
            print(error)
        }
        // MARK: - 앱 종료나 시작 시, FileManagerService.shared.deleteAllImages()
    }
    
    func updateProfileSubmit() {
        if user.name != updateUser.name {
            Task {
                try? await container.services.userService.updateName(userId: userId, name: updateUser.name)
            }
        }
        // TODO: - 상메 없을 떄 처리 추가
        if user.description != updateUser.description, let updateDescription = updateUser.description {
            Task {
                try? await container.services.userService.updateDescription(userId:userId, description: updateDescription)
            }
        }
        // TODO: - 프사 없을 떄 처리 추가
        if user.profileURL != updateUser.profileURL, let fileURLString = updateUser.profileURL {
            Task {
                
                if let data = container.services.imageCacheService.tempImage(for: fileURLString),
                   let datadata = data.pngData(),
                   let uploadedURL = try? await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: datadata) {
                    let uploadedURLString = uploadedURL.absoluteString
                    try? await container.services.userService.updateProfileURL(userId: userId, urlString: uploadedURLString)
                    updateUser.profileURL = uploadedURLString
                }
            }
        }
    }
}

extension MyProfileViewModel {
    var defualtUserDescription: String{
        isEditMode ? "상태메시지를 입력하세요." : " "
    }
}
