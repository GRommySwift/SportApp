//
//  EventRemote.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation

public struct EventRemote: Codable {
    public var id: String // uuid string
    public var title: String
    public var place: String
    public var duration: Double
    public var storage: StorageType
}
extension EventRemote {
    init(from domain: Event) {
        self.id = domain.id.uuidString
        self.title = domain.title
        self.place = domain.place
        self.duration = domain.duration
        self.storage = domain.storageType
    }
    func toDomain() -> Event? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return Event(id: uuid, title: title, place: place, duration: duration, storageType: storage)
    }
}
