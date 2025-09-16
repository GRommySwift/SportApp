//
//  ResultItemDomain.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
struct ResultItemDomain {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: UUID { events.id }
        var events: Event
    }
}
