//
//  AddNewResultView.swift
//  SportApp
//
//  Created by Roman on 13/09/2025.
//

import SwiftUI
import ComposableArchitecture
import SharedModels

struct AddNewResultView: View {
    let store: StoreOf<AddNewResultDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        Spacer()
                        CustomTextField(text: viewStore.binding(
                            get: \.title,
                            send: AddNewResultDomain.Action.titleChanged
                        ), title: "Title")
                        CustomTextField(text: viewStore.binding(
                            get: \.place,
                            send: AddNewResultDomain.Action.placeChanged
                        ), title: "Place")
                        CustomTextField(text: viewStore.binding(
                            get: \.duration,
                            send: AddNewResultDomain.Action.durationChanged
                        ), title: "Duration")
                        .keyboardType(.numberPad)
                        StoragePicker(store: store, viewStore: viewStore)
                        Spacer()
                        Button("Save") {
                            viewStore.send(.saveTapped)
                        }
                        .buttonStyle(SaveButtonStyle())
                        Spacer()
                        
                    }
                    .padding()
                    .navigationTitle("Add Result").navigationBarTitleDisplayMode(.inline)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
}

extension AddNewResultView {
    
    //MARK: - View elements
    
    struct CustomTextField: View {
        @FocusState var isActive
        @Binding var text: String
        var title: String
        
        var body: some View {
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55).focused($isActive)
                    .background(Color(.black.opacity(0.06)), in: .rect(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    }
                Text(title)
                    .padding(.horizontal)
                    .offset(y: (isActive || !text.isEmpty) ? -40 : 0)
                    .animation(.spring, value: isActive)
                    .foregroundStyle(isActive ? Color(.black) : Color(.gray))
                    .onTapGesture {
                        isActive = true
                    }
            }
        }
    }
    
    struct StoragePicker: View {
        let store: StoreOf<AddNewResultDomain>
        let viewStore : ViewStore<AddNewResultDomain.State, AddNewResultDomain.Action>
        
        var body: some View {
            HStack {
                Text("Select Storage")
                    .foregroundStyle(.gray)
                Spacer()
                Picker("Storage", selection: viewStore.binding(get: \.storage, send: AddNewResultDomain.Action.storageChanged)) {
                    Text("Local").tag(StorageType.local)
                    Text("Remote").tag(StorageType.remote)
                }
                .pickerStyle(.menu)
            }
            .padding(10)
            .background(Color(.black.opacity(0.06)))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }        }
    }
    
    //MARK: - View modifiers
    
    struct SaveButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .frame(width: 200)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}


#Preview {
    AddNewResultView(store: Store(initialState: AddNewResultDomain.State()) {
        AddNewResultDomain()
    })
}
