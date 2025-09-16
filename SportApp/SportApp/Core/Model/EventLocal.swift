//
//  EventLocal.swift
//  SportApp
//
//  Created by Roman on 17/09/2025.
//

import Foundation
import SwiftData
import SharedModels

@Model
final class EventLocal {
    var id: UUID
    var title: String
    var place: String
    var duration: Double
    var storage: StorageType?

    init(id: UUID = UUID(), title: String, place: String, duration: Double, storage: StorageType) {
        self.id = id
        self.title = title
        self.place = place
        self.duration = duration
        self.storage = storage
    }
}

extension EventLocal {
    func toDomain() -> Event {
        Event(id: id, title: title, place: place, duration: duration, storageType: storage ?? .local)
    }

    convenience init(from domain: Event) {
        self.init(id: domain.id, title: domain.title, place: domain.place, duration: domain.duration, storage: domain.storageType)
    }
}
