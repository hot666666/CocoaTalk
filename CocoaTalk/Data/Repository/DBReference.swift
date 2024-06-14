//
//  DBReference.swift
//  CocoaTalk
//
//  Created by hs on 6/14/24.
//

import FirebaseDatabase
import Combine

protocol DBReferenceType {
    func setValue(key: String, path: String?, value: Any) async throws
    func fetch(key: String, path: String?) async throws -> Any?
    func setValues(_ values: [String: Any]) async throws
    func childByAutoId(key: String, path: String?) -> String?
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func removeObservedHandlers()
}

class DBReference: DBReferenceType {
    
    var db: DatabaseReference = Database.database().reference()
    
    var observedHandlers: [UInt] = []
    
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
        try await db.child(getPath(key: key, path: path)).setValue(value)
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        try await db.child(getPath(key: key, path: path)).getData().value
    }
    
    func setValues(_ values: [String: Any]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.db.updateChildValues(values) { error, _ in
                if let error = error {
                    continuation.resume(throwing: DBError.error(error))
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        db.child(getPath(key: key, path: path)).childByAutoId().key
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
       
        let handler = db.child(getPath(key: key, path: path)).observe(.childAdded) { snapshot in
            subject.send(snapshot.value)
        }
        
        observedHandlers.append(handler)
        
        return subject.eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        observedHandlers.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}
