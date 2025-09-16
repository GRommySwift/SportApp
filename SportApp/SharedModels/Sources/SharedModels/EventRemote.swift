//
//  EventRemote.swift
//  SharedModels
//
//  Created by Roman on 16/09/2025.
//

import Foundation

public struct EventRemote: Codable, Sendable {
    public var id: String   // UUID string
    public var title: String
    public var place: String
    public var duration: Double
    public var storage: StorageType

    public init(id: String, title: String, place: String, duration: Double, storage: StorageType) {
        self.id = id
        self.title = title
        self.place = place
        self.duration = duration
        self.storage = storage
    }
}

public extension EventRemote {
    init(from domain: Event) {
        self.id = domain.id.uuidString
        self.title = domain.title
        self.place = domain.place
        self.duration = domain.duration
        self.storage = domain.storageType
    }

    func toDomain() -> Event? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return Event(
            id: uuid,
            title: title,
            place: place,
            duration: duration,
            storageType: storage
        )
    }
}
