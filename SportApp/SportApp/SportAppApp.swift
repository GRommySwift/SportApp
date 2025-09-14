//
//  SportAppApp.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct SportAppApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: EventLocal.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    static let store: StoreOf<ListOfResultDomain> = {
        let container = try! ModelContainer(for: EventLocal.self)
           let modelContext = ModelContext(container)
           return withDependencies {
               $0.localEventStore = SwiftDataEventStore(context: modelContext)
           } operation: {
               Store(initialState: ListOfResultDomain.State()) {
                   ListOfResultDomain()
               }
           }
    }()
    
    var body: some Scene {
        WindowGroup {
            ListOfResultView(store: SportAppApp.store)
                .modelContainer(container)
        }
    }
    
   
}
