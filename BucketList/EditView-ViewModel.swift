//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Philip Janzel Paradeza on 2025-08-04.
//

import Foundation
extension EditView{
    @Observable 
    class ViewModel{
        var name : String
        var description : String
        var loadingState = LoadingState.loading
        var pages = [Page]()
        var location: Location
        init(passedLoc: Location){
            location = passedLoc
            name = passedLoc.name
            description = passedLoc.description
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
        
        func save() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
    }
}
