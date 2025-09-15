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
    @State var uiFilter: EventFilter = .all
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                List {
                    ForEachStore(store.scope(state: \.events, action: \.event)) { productStore in
                        ResultItemView(store: productStore)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(10)
                    }
                    .onDelete { indexSet in
                        let ids = indexSet.map { viewStore.events[$0].id }
                        viewStore.send(.delete(ids: ids))
                    }
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity)
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

                            Picker("", selection: $uiFilter) {
                                ForEach(EventFilter.allCases, id: \.self) {
                                    Text($0.rawValue).tag($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onChange(of: uiFilter) { new in
                                viewStore.send(.toggleFilter(new))
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
