// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Event: Identifiable, Equatable, Codable, Sendable {
    public var id: UUID
    public var title: String
    public var place: String
    public var duration: Double
    public var storageType: StorageType

    public init(
        id: UUID = UUID(),
        title: String,
        place: String,
        duration: Double,
        storageType: StorageType
    ) {
        self.id = id
        self.title = title
        self.place = place
        self.duration = duration
        self.storageType = storageType
    }
}

public enum StorageType: Codable, Sendable {
    case local
    case remote
}
