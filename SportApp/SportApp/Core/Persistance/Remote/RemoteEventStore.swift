//
//  RemoteEventStore.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation

public protocol RemoteEventStore {
    func fetchAll() async throws -> [Event]
    func save(_ event: Event) async throws
    func delete(id: UUID) async throws
}
