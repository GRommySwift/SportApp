//
//  ResultItemView.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct ResultItemView: View {
    let store: StoreOf<ResultItemDomain>
    
    var body: some View {
        VStack {
            Text(store.events.place)
            Text(store.events.title)
            Text(store.events.duration.description)
        }
    }
}

#Preview {
    ResultItemView(store: Store(initialState: ResultItemDomain.State(events: testResult)) {
        ResultItemDomain()
    })
}
