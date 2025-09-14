//
//  AddNewResultDomain.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

@Reducer
struct AddNewResultDomain {
    @ObservableState
    struct State: Equatable {
        var title = ""
        var place = ""
        var duration: Double = 0
        var storage: StorageType = .local
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case titleChanged(String)
        case placeChanged(String)
        case durationChanged(Double)
        case storageChanged(StorageType)
        case saveTapped
        case saveResponse(PersistenceResponse)
    }
    
    @Dependency(\.localEventStore) var localStore
    
    var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case let .titleChanged(newTitle):
                    state.title = newTitle
                    return .none
                case let .placeChanged(newPlace):
                    state.place = newPlace
                    return .none
                case let .durationChanged(newDuration):
                    state.duration = newDuration
                    return .none
                case let .storageChanged(selectedStorage):
                    state.storage = selectedStorage
                    return .none
                case .saveTapped:
                    state.errorMessage = nil
                    let event = Event(id: UUID(), title: state.title, place: state.place, duration: state.duration)
                    
                    return .run { send in
                        do {
                            try await localStore.save(event)
                            await send(.saveResponse(.success))
                        } catch {
                            await send(.saveResponse(.failed(error.localizedDescription)))
                        }
                    }
                case .saveResponse:
                    return .none
                }
            }
        }
}
