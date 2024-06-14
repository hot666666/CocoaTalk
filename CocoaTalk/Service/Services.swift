//
//  Services.swift
//  CocoaTalk
//
//  Created by 최하식 on 5/30/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var chatService: ChatServiceType { get set }
    var photoPickerService: PhotoPickerServiceType { get set }
    var uploadService: UploadServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
    var chatRoomService: ChatRoomServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var chatService: ChatServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    var imageCacheService: ImageCacheServiceType
    var chatRoomService: ChatRoomServiceType
    
    init(
        authService: AuthenticationServiceType = AuthenticationService(),
        userService: UserServiceType = UserService(dbRepository: UserDBRepository()),
        chatService: ChatServiceType = ChatService(dbRepository: ChatDBRepository()),
        photoPickerService: PhotoPickerServiceType = PhotoPickerService(),
        uploadService: UploadServiceType = UploadService(provider: UploadProvider()),
        imageCacheService: ImageCacheServiceType = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage()),
        chatRoomService: ChatRoomServiceType = ChatRoomService(dbRepository: ChatRoomDBRepository())
    ) {
        self.authService = authService
        self.userService = userService
        self.chatService = chatService
        self.photoPickerService = photoPickerService
        self.uploadService = uploadService
        self.imageCacheService = imageCacheService
        self.chatRoomService = chatRoomService
    }
}

class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var chatService: ChatServiceType = StubChatService()
    var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
    var uploadService: UploadServiceType = StubUploadService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
    var chatRoomService: ChatRoomServiceType = StubChatRoomService()
}
