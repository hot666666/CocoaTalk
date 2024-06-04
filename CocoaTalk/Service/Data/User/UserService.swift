//
//  UserService.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/1/24.
//

import Foundation

protocol UserServiceType {
    func loginUser(_ user: User) async throws -> User
    func loadFriends(_ user: User) async throws -> [User]
    func getUser(userId: String) async throws -> User
    func updateName(userId: String, name: String) async throws
    func updateDescription(userId: String, description: String) async throws
    func updateProfileURL(userId: String, urlString: String) async throws
}

class UserService: UserServiceType {
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func loginUser(_ user: User) async throws -> User {
        do {
            let existingUser = try await dbRepository.getUser(userId: user.id)
            return existingUser.toModel()
        } catch DBRepositoryError.notFoundError {
            try await dbRepository.addUser(user.toObject())
            return user
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func loadFriends(_ user: User) async throws -> [User] {
        do {
            let friends = try await dbRepository.loadFriends(user.toObject())
            return friends.map { $0.toModel() }
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func getUser(userId: String) async throws -> User {
        do {
            let existingUser = try await dbRepository.getUser(userId: userId)
            return existingUser.toModel()
        } catch {
            throw ServiceError.error(error)
        }
    }
    
    func updateName(userId: String, name: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "name", value: name)
    }
    
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description)
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString)
    }
    
    
}

class StubUserService: UserServiceType {
    func loginUser(_ user: User) async throws -> User {
        .stubUser
    }
    
    func loadFriends(_ user: User) async throws -> [User] {
        User.stubUsers
    }
    
    func getUser(userId: String) async throws -> User {
        User(id: userId, name: "이름")
    }
    
    func updateName(userId: String, name: String) async throws {
    }
    
    func updateDescription(userId: String, description: String) async throws {
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
    }
}
