//
//  ListOfResultDomain.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ListOfResultDomain {
    @ObservableState
    struct State: Equatable {
        @Presents var addNewResult: AddNewResultDomain.State?
        var events: IdentifiedArrayOf<ResultItemDomain.State> = []
        var isLoading: Bool = false
        var error: String?
    }
    
    enum Action: Equatable {
        case onAppear
        case setEvents([Event])
        case setError(String)
        case showAdd
        case dismissAdd(PresentationAction<AddNewResultDomain.Action>)
        case filter
        case event(id: ResultItemDomain.State.ID, action: ResultItemDomain.Action)
        case add(PresentationAction<AddNewResultDomain.Action>)
    }
    
    @Dependency(\.localEventStore) var localStore
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.error = nil
                return .run { send in
                    do {
                        let items = try await localStore.fetchAll()
                        await send(.setEvents(items))
                    } catch {
                        await send(.setError(error.localizedDescription))
                    }
                }
            case let .setEvents(items):
                state.isLoading = false
                state.events = IdentifiedArray(uniqueElements: items.map { Event in
                    ResultItemDomain.State(events: Event)
                })
                return .none
            case let .setError(error):
                    state.isLoading = false
                    state.error = error
                    return .none
            case .showAdd:
                state.addNewResult = AddNewResultDomain.State()
                return .none
            case .dismissAdd(.dismiss):
                state.addNewResult = nil
                return .none
            case .filter:
                return .none
            case .event:
                return .none
            default:
                return .none
            }
        }
    
        .ifLet(\.$addNewResult, action: \.dismissAdd) {
            AddNewResultDomain()
        }
    }
}
