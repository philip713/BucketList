//
//  EditView.swift
//  BucketList
//
//  Created by Philip Janzel Paradeza on 2025-07-30.
//

import SwiftUI
enum LoadingState{
    case loading, loaded, failed
}
struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel

    var onSave: (Location) -> Void
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid){ page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("please try again later.")
                    }
                }
            }
            .navigationTitle("place details")
            .toolbar{
                Button("Save"){
                    onSave(viewModel.save())
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(passedLoc: location))
        
        
    }
    
}

#Preview {
    EditView(location: .example) {_ in}
}
