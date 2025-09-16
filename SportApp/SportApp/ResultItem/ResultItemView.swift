//
//  ResultItemView.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import ComposableArchitecture
import SharedModels

struct ResultItemView: View {
    let store: StoreOf<ResultItemDomain>
    
    var body: some View {
        VStack(spacing: 0) {
            viewLabels(store: store)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(store.events.storageType == .local ? .green.opacity(0.3) : .blue.opacity(0.3)))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
    }
}

#Preview {
    ResultItemView(store: Store(initialState: ResultItemDomain.State(events: testResult)) {
        ResultItemDomain()
    })
}

//MARK: View elements

extension ResultItemView {
    func viewLabels(store: StoreOf<ResultItemDomain>) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Event title:")
                Text("Place of event:")
                Text("Place of event:")
            }
            .font(.headline)
            .padding(.trailing, 50)
            VStack(alignment: .leading) {
                Text(store.events.title)
                Text(store.events.duration.description)
                Text(store.events.place)
            }
            .font(.headline)
            Spacer()
        }
    }
}
