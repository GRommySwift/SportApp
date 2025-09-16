//
//  Dependencies+EventStores.swift
//  SportApp
//
//  Created by Roman on 15/09/2025.
//

import Foundation
import ComposableArchitecture
import RemoteEventStore

private enum RemoteEventStoreKey: DependencyKey {
  static var liveValue: RemoteEventStore = {
    fatalError("Provide a real RemoteEventStore in App")
  }()
}
extension DependencyValues {
  var remoteEventStore: RemoteEventStore {
    get { self[RemoteEventStoreKey.self] }
    set { self[RemoteEventStoreKey.self] = newValue }
  }
}
