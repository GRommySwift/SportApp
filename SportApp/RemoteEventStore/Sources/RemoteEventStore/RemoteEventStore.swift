// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SharedModels

public protocol RemoteEventStore: Sendable {
    func fetchAll() async throws -> [Event]
    func save(_ event: Event) async throws
    func delete(id: UUID) async throws
}
