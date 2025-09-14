//
//  Dependencies+LocalEventStore.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation
import ComposableArchitecture

private enum LocalEventStoreKey: DependencyKey {
  static var liveValue: LocalEventStore = {
    fatalError("Provide LocalEventStore in App")
  }()
}

extension DependencyValues {
  var localEventStore: LocalEventStore {
    get { self[LocalEventStoreKey.self] }
    set { self[LocalEventStoreKey.self] = newValue }
  }
}
