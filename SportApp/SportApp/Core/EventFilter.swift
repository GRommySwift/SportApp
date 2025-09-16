//
//  EventFilter.swift
//  SportApp
//
//  Created by Roman on 15/09/2025.
//

import Foundation

enum EventFilter: String , CaseIterable {
    
    static let allValues: [EventFilter] = [.all, .local, .remote]
    
    case all = "All"
    case local = "Local"
    case remote = "Remote"
}
