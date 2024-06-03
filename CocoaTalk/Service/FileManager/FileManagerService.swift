//
//  FileManagerService.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/3/24.
//

import Foundation

enum FileManagerServiceError: Error {
    case createDirectroyError
    case getDirectoryError
    case writeDataError
    case removeItemError
    case loadDataError
    case fileNotFoundError
}

actor FileManagerService {
    static let shared = FileManagerService()
    
    private init() {}
    
    private let fileManager = FileManager.default
    private let directoryURL = FileManager.default.temporaryDirectory.appendingPathComponent("selectedImage")
    
    func saveImage(data: Data, fileName: String) async throws -> URL {
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                throw FileManagerServiceError.createDirectroyError
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw FileManagerServiceError.writeDataError
        }
        return fileURL
    }
    
    func loadImage(fileName: String) async throws -> Data {
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                return data
            } catch {
                throw FileManagerServiceError.loadDataError
            }
        } else {
            throw FileManagerServiceError.fileNotFoundError
        }
    }
    
    func deleteImage(fileName: String) async throws {
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                throw FileManagerServiceError.removeItemError
            }
        }
    }
    
    func deleteAllImages() async throws {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            switch error {
            case CocoaError.fileReadNoSuchFile:
                throw FileManagerServiceError.getDirectoryError
            default:
                throw FileManagerServiceError.removeItemError
            }
        }
    }
}
