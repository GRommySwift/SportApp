//
//  EventResult.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import Foundation

struct EventResult: Identifiable, Equatable, Codable {
    var id: UUID
    var title: String
    var place: String
    var duration: TimeInterval
}

var testResult = EventResult(id: UUID(), title: "Football", place: "Manchester", duration: 100)
