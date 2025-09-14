//
//  ListOfResultView.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct ListOfResultView: View {
    let store: StoreOf<ListOfResultDomain>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                List {
                    ForEachStore(store.scope(state: \.events, action: \.event)) { productStore in
                        ResultItemView(store: productStore)
                    }
                }
                .navigationTitle("SportApp")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            store.send(.showAdd)
                        }
                        .padding(.trailing, 10)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Filter") {
                            //
                        }
                    }
                }
                .navigationDestination(
                    store: store.scope(state: \.$addNewResult, action: \.dismissAdd)
                ) { addStore in
                AddNewResult(store: addStore)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    ListOfResultView(store: Store(initialState: ListOfResultDomain.State()) {
        ListOfResultDomain()
    })
}
