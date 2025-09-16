//
//  ListOfResultDomain.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
struct ListOfResultDomain {
    @ObservableState
    struct State: Equatable {
        @Presents var addNewResult: AddNewResultDomain.State?
        var events: IdentifiedArrayOf<ResultItemDomain.State> = []
        var isLoading: Bool = false
        var error: String?
        var selectedFilter: EventFilter = .all
        var localItems: [Event] = []
        var remoteItems: [Event] = []

        mutating func mergeRecords() {
            let source: [Event]
            switch selectedFilter {
            case .all:
                source = localItems + remoteItems
            case .local:
                source = localItems
            case .remote:
                source = remoteItems
            }

            self.events = IdentifiedArray(uniqueElements: source.map { event in
                ResultItemDomain.State(events: event)
            })
        }
    }

    enum Action: Equatable {
        case onAppear
        case localFetched([Event])
        case remoteFetched([Event])
        case setError(String)
        case goToAddNewResultView
        case dismissAdd(PresentationAction<AddNewResultDomain.Action>)
        case toggleFilter(EventFilter)
        case event(id: ResultItemDomain.State.ID, action: ResultItemDomain.Action)
        case delete(ids: [UUID])
        case deleteSuccess(UUID)
        case deleteFailure(String)
    }

    @Dependency(\.localEventStore) var localStore
    @Dependency(\.remoteEventStore) var remoteStore

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.error = nil
                
                return .merge(
                    .run { send in
                        do {
                            let local = try await localStore.fetchAll()
                            await send(.localFetched(local))
                        } catch {
                            await send(.setError(error.localizedDescription))
                        }
                    },
                    .run { send in
                        do {
                            let remote = try await remoteStore.fetchAll()
                            await send(.remoteFetched(remote))
                        } catch {
                            await send(.setError(error.localizedDescription))
                        }
                    }
                )

            case let .localFetched(items):
                state.localItems = items
                state.mergeRecords()
                state.isLoading = false
                return .none

            case let .remoteFetched(items):
                state.remoteItems = items
                state.mergeRecords()
                state.isLoading = false
                return .none

            case let .setError(errorMessage):
                state.isLoading = false
                state.error = errorMessage
                return .none

            case .goToAddNewResultView:
                state.addNewResult = AddNewResultDomain.State()
                return .none
                
            case let .dismissAdd(.presented(.saveResponse(.success(event)))):
                switch event.storageType {
                case .local:
                    state.localItems.insert(event, at: 0)
                case .remote:
                    state.remoteItems.insert(event, at: 0)
                }
                state.mergeRecords()
                state.addNewResult = nil
                return .none

            case let .dismissAdd(.presented(.saveResponse(.failed(message)))):
                state.error = message
                return .none

            case .dismissAdd(.dismiss):
                state.addNewResult = nil
                return .none

            case let .toggleFilter(filter):
                state.selectedFilter = filter
                state.mergeRecords()
                return .none

            case let .delete(ids):
                let eventsToDelete = state.events
                    .filter { ids.contains($0.id) }
                    .map { ($0.id, $0.events) }

                for id in ids {
                    state.events.remove(id: id)
                }
                
                state.localItems.removeAll { ids.contains($0.id) }
                state.remoteItems.removeAll { ids.contains($0.id) }
                
                let effects: [Effect<Action>] = eventsToDelete.map { (id, event) in
                    .run { send in
                        do {
                            switch event.storageType {
                            case .local:
                                try await localStore.delete(id: id)
                            case .remote:
                                try await remoteStore.delete(id: id)
                            }
                            await send(.deleteSuccess(id))
                        } catch {
                            await send(.deleteFailure(error.localizedDescription))
                        }
                    }
                }
                return .merge(effects)

            case .deleteSuccess:
                return .none

            case let .deleteFailure(message):
                state.error = message
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
