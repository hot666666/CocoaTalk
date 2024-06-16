//
//  UploadProvider.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import Foundation
import FirebaseStorage

enum UploadError: Error {
    case error(Error)
}

protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) async throws -> URL
}

class UploadProvider: UploadProviderType {
    
    let storageRef = Storage.storage().reference()
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
}
