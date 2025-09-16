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
                            store.send(.goToAddNewResultView)
                        }
                        .padding(.trailing, 10)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        DropdownMenu(selectedOption: $uiFilter)
                            .onChange(of: uiFilter) {
                                viewStore.send(.toggleFilter(uiFilter))
                            }
                    }
                }
                .navigationDestination(
                    store: store.scope(state: \.$addNewResult, action: \.dismissAdd)
                ) { addStore in
                    AddNewResultView(store: addStore)
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

extension ListOfResultView {
    struct DropdownMenu: View {
        @Binding var selectedOption: EventFilter
        
        var body: some View {
            Menu {
                Button("All", action: { selectedOption = .all })
                Button("Local", action: { selectedOption = .local })
                Button("Remote", action: { selectedOption = .remote })
            } label: {
                Label("", systemImage: "line.3.horizontal.decrease.circle")
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}



