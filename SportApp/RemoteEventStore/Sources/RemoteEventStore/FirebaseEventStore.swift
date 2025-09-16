//
//  FirebaseEventStore.swift
//  RemoteEventStore
//
//  Created by Roman on 16/09/2025.
//

import Foundation
import FirebaseFirestore
import SharedModels

actor FirebaseEventStore: RemoteEventStore {
    private let db: Firestore
    private let collection: CollectionReference
    
    public init(firestore: Firestore = Firestore.firestore(), collectionName: String = "events") {
        self.db = firestore
        self.collection = db.collection(collectionName)
    }
    
    public func fetchAll() async throws -> [Event] {
        return try await withCheckedThrowingContinuation { cont in
            collection.getDocuments { snapshot, error in
                if let error = error { cont.resume(throwing: error); return }
                guard let docs = snapshot?.documents else { cont.resume(returning: []); return }
                var result: [Event] = []
                for doc in docs {
                    do {
                        let data = try doc.data(as: EventRemote.self)
                        if let verifiedData = data.toDomain() {
                            result.append(verifiedData)
                        }
                    } catch {
                        print("DTO decode error:", error)
                    }
                }
                cont.resume(returning: result)
            }
        }
    }
    
    public func save(_ event: Event) async throws {
        let data = EventRemote(from: event)
        return try await withCheckedThrowingContinuation { cont in
            do {
                let docRef = collection.document(data.id)
                try docRef.setData(from: data) { error in
                    if let error = error {
                        cont.resume(throwing: error)
                    } else {
                        cont.resume(returning: ())
                    }
                }
            } catch {
                cont.resume(throwing: error)
            }
        }
    }
    
    public func delete(id: UUID) async throws {
        return try await withCheckedThrowingContinuation { cont in
            collection.document(id.uuidString).delete { error in
                if let error = error {
                    cont.resume(throwing: error)
                } else {
                    cont.resume(returning: ())
                }
            }
        }
    }
}
