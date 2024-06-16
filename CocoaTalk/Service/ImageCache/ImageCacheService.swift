//
//  ImageCacheService.swift
//  LMessenger
//
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
    func tempImage(for key: String) -> UIImage?
    func store(for key: String, image: UIImage, toDisk: Bool)
}

class ImageCacheService: ImageCacheServiceType {
    /// key로 이미지 로드를 요청 시, 다음 과정을 거쳐 이미지 전달
    /// 1. Disk에 없으면 remoteImage -> Disk에 저장 - type Data
    /// 2. Disk에 있으면 imageWithDiskCache -> Memory에 저장 - type UIImage
    
    let memoryStorage: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    func tempImage(for key: String) -> UIImage? {
        memoryStorage.value(for: key)
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        return imageWithMemoryCache(for: key)
            .flatMap { [weak self] image -> AnyPublisher<UIImage?, Never> in
                /// self? 를 매번 수행 안시켜도, 한번에 처리가능
                /// 또한 그냥 return nil이 수행될 때를 깔끔하게 작성가능(Empty Publisher를 반환)
                guard let `self` else { return Empty().eraseToAnyPublisher() }
                
                if let image {
                    return Just(image).eraseToAnyPublisher()
                }
                
                return self.imageWithDiskCache(for: key)
            }
            .eraseToAnyPublisher()
    }
}
    
extension ImageCacheService {
    
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        return Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        .flatMap { [weak self] image -> AnyPublisher<UIImage?, Never> in
            guard let `self` else { return Empty().eraseToAnyPublisher() }
            
            if let image {
                return Just(image)
                    /// Publisher로 부터 image를 받으면(receiveOutput), store 수행
                    .handleEvents(receiveOutput: { image in
                        guard let image else { return }
                        self.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            }
            return self.remoteImage(for: key)
        }
        .eraseToAnyPublisher()
    }
    
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            /// Publisher로 부터 image를 받으면(receiveOutput), store 수행
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

class StubImageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func tempImage(for key: String) -> UIImage? {
        return nil
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool) {
        
    }
}
