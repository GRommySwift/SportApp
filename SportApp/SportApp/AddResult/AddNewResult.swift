//
//  AddNewResult.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct AddNewResult: View {
    let store: StoreOf<AddNewResultDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    TextField("", text: viewStore.binding(
                        get: \.title,
                        send: AddNewResultDomain.Action.titleChanged
                    ))
                    .background(Color.gray.opacity(0.5))
                    TextField("", text: viewStore.binding(
                        get: \.place,
                        send: AddNewResultDomain.Action.placeChanged
                    ))
                    .background(Color.gray.opacity(0.5))
                    TextField("", value: viewStore.binding(
                        get: \.duration,
                        send: AddNewResultDomain.Action.durationChanged
                    ),
                        formatter: NumberFormatter()
                    )
                    .background(Color.gray.opacity(0.5))
                    .keyboardType(.numberPad)
                }
                .navigationTitle("Add Result")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            viewStore.send(.saveTapped)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddNewResult(store: Store(initialState: AddNewResultDomain.State()) {
        AddNewResultDomain()
    })
}
