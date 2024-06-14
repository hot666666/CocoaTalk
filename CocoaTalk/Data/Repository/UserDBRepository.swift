//
//  UserRepository.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation
import FirebaseDatabase

enum DBRepositoryError: Error {
    case encodingError
    case decodingError
    case setValueError
    case getDataError
    case notFoundError
    case addFreindError
}

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) async throws
    func updateUser(userId: String, key: String, value: Any) async throws 
    func getUser(userId: String) async throws -> UserObject
    func loadFriends(_ object: UserObject) async throws -> [UserObject]
    func addFriend(_ object: UserObject, loggedInUserId: String) async throws
}

class UserDBRepository: UserDBRepositoryType {
    var db: DatabaseReference = Database.database().reference()
    
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }

    func updateUser(userId: String, key: String, value: Any) async throws  {
        let path = getPath(key: DBKey.Users, path: "\(userId)/\(key)")
 
        try await db.child(path).setValue(value)
    }
    
    func getUser(userId: String) async throws -> UserObject {
        let path = getPath(key: DBKey.Users, path: userId)
 
        guard let snapshot = try? await db.child(path).getData() else {
            throw DBRepositoryError.getDataError
        }
        if !snapshot.exists() {
            throw DBRepositoryError.notFoundError
        }
        
        guard 
            let data = snapshot.value,
            let jsonData = try? JSONSerialization.data(withJSONObject: data),
            /// Firebase Database는 NSNumber, NSString, NSDictionary, NSArray 타입의 객체만 사용
            /// 따라서 디코딩된 Data 객체를 Swift 타입으로 변환해야함
            let userObj = try? JSONDecoder().decode(UserObject.self, from: jsonData)
        else {
            throw DBRepositoryError.decodingError
        }
        
        return userObj
    }
    
    func addUser(_ object: UserObject) async throws {
        
        guard 
            let data = try? JSONEncoder().encode(object),
            /// Firebase Database는 NSNumber, NSString, NSDictionary, NSArray 타입의 객체만 저장가능
            /// 따라서 인코딩된 Data 객체를 NSDictionary나 NSArray로 변환해야함
            let jsonEncodedUser = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        else {
            throw DBRepositoryError.encodingError
        }
        
        let path = getPath(key: DBKey.Users, path: object.id)

        do {
            try await db.child(path).setValue(jsonEncodedUser)
        } catch {
            throw DBRepositoryError.setValueError
        }
    }
    
    
    func addFriend(_ object: UserObject, loggedInUserId: String) async throws {
        let path = getPath(key: DBKey.Friends, path: "\(loggedInUserId)/\(object.id)")
        
        guard 
            let data = try? JSONEncoder().encode(object),
            let jsonEncodedUser = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        else {
            throw DBRepositoryError.encodingError
        }
        
        do {
            let snapshot = try await db.child(path).getData()
            if !snapshot.exists() {
                try await db.child(path).setValue(jsonEncodedUser)
            }
        } catch {
            throw DBRepositoryError.setValueError
        }
    }
    
    
    func loadFriends(_ object: UserObject) async throws -> [UserObject] {
        let path = getPath(key: DBKey.Friends, path: object.id)
 
        guard let snapshot = try? await db.child(path).getData() else {
            throw DBRepositoryError.getDataError
        }
        if !snapshot.exists() { return [] }
        
        guard
            let data = snapshot.value,
            let jsonData = try? JSONSerialization.data(withJSONObject: data),
            let userObjsDict = try? JSONDecoder().decode([String: UserObject].self, from: jsonData)  /// []이 있다면 뒤에 .self 추가로 타입 의미
        else {
            throw DBRepositoryError.decodingError
        }
        
        return Array(userObjsDict.values)
    }
}
