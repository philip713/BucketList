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
    var location: Location
    @State private var name: String
    @State private var description: String
    var onSave: (Location) -> Void
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby..."){
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid){ page in
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
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            //got some daa back
            let items = try JSONDecoder().decode(Result.self, from: data)
            //sucess convert to pages array
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}

#Preview {
    EditView(location: .example) {_ in}
}
