//
//  ListOfResultView.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import SwiftData

struct ListOfResultView: View {
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Text("Place: \(testResult.place)")
                    Text("Title: \(testResult.title)")
                    Text("Duration: \(testResult.duration.description)")
                }
            }
            .navigationTitle("SportApp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        //
                    }
                    .padding(.trailing, 10)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filter") {
                        //
                    }
                }
            }
        }
    }
}

#Preview {
    ListOfResultView()
}
