//
//  SwiftDataEventStore.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation
import SwiftData

@MainActor
public final class SwiftDataEventStore: LocalEventStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    public func fetchAll() async throws -> [Event] {
        let fetchDescriptor = FetchDescriptor<EventLocal>()
        let list = try context.fetch(fetchDescriptor)
        return list.map { $0.toDomain() }
    }

    public func save(_ event: Event) async throws {
        let entity = EventLocal(from: event)
        context.insert(entity)
        try context.save()
    }

    public func delete(id: UUID) async throws {
        let fetchDescriptor = FetchDescriptor<EventLocal>()
        let items = try context.fetch(fetchDescriptor)
        if let toDelete = items.first(where: { $0.id == id }) {
            context.delete(toDelete)
            try context.save()
        }
    }
    
    public func clearAll() async throws {
        try? self.context.clearAllEvents()
    }
}

extension ModelContext {
    func clearAllEvents() throws {
        let fetch = FetchDescriptor<EventLocal>()
        let events = try self.fetch(fetch)
        for event in events {
            self.delete(event)
        }
        try self.save()
    }
}
