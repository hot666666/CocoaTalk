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
    var photoPickerService: PhotoPickerServiceType { get set }
    var uploadService: UploadServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    var imageCacheService: ImageCacheServiceType
    
    init(
        authService: AuthenticationServiceType = AuthenticationService(),
        userService: UserServiceType = UserService(dbRepository: UserDBRepository()),
        photoPickerService: PhotoPickerServiceType = PhotoPickerService(),
        uploadService: UploadServiceType = UploadService(provider: UploadProvider()),
        imageCacheService: ImageCacheServiceType = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
    ) {
        self.authService = authService
        self.userService = userService
        self.photoPickerService = photoPickerService
        self.uploadService = uploadService
        self.imageCacheService = imageCacheService
    }
}

class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
    var uploadService: UploadServiceType = StubUploadService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
}
