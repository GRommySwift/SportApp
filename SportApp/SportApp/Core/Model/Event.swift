//
//  EventResult.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import Foundation
import SwiftData

public struct Event: Equatable, Codable, Identifiable {
    public var id: UUID
    public var title: String
    public var place: String
    public var duration: Double
}

var testResult = Event(id: UUID(), title: "Football", place: "Manchester", duration: 100)
