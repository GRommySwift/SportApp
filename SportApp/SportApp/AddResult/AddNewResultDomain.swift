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
        var duration = ""
        var storage: StorageType = .local
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case titleChanged(String)
        case placeChanged(String)
        case durationChanged(String)
        case storageChanged(StorageType)
        case saveTapped
        case saveResponse(PersistenceResponse)
        case dismiss
    }
    
    @Dependency(\.localEventStore) var localStore
    @Dependency(\.remoteEventStore) var remoteStore
    
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
                    let event = Event(id: UUID(), title: state.title, place: state.place, duration: Double(state.duration) ?? 0.0, storageType: state.storage)
                    
                    return .run { send in
                        do {
                            switch event.storageType {
                            case .local:
                                try await localStore.save(event)
                            case .remote:
                                try await remoteStore.save(event)
                            }
                            await send(.saveResponse(.success(event)))
                        } catch {
                            await send(.saveResponse(.failed(error.localizedDescription)))
                        }
                    }
                case .saveResponse(.success(_)):
                    return .none
                case let .saveResponse(.failed(errorText)):
                    state.errorMessage = errorText
                    return.none
                case .dismiss:
                    state.title = ""
                    state.place = ""
                    state.duration = ""
                    return.none
                }
            }
        }
}
