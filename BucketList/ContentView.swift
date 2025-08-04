//
//  ContentView.swift
//  BucketList
//
//  Created by Philip Janzel Paradeza on 2025-07-28.
//

import SwiftUI
import MapKit
import LocalAuthentication
struct ContentView: View {
   let  startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    @State private var viewModel = ViewModel()
    @State private var mapStyle = MapStyle.standard
    var body: some View {
        if viewModel.isUnlocked{
            VStack{
                MapReader{ proxy in
                    Map(initialPosition: startPosition){
                        ForEach(viewModel.locations){ location in
                            Annotation(location.name, coordinate: location.coordinate){
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(mapStyle)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local){
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(item: $viewModel.selectedPlace){ place in
                            Text(place.name)
                            EditView(location: place){
                                viewModel.update(location: $0)
                            }
                        }
                }
                HStack{
                    Spacer()
                    Button("Standard"){
                        mapStyle = .standard
                    }
                    Spacer()
                    Button("Hybrid"){
                        mapStyle = .hybrid
                    }
                    Spacer()
                    Button("Imagery"){
                        mapStyle = .imagery
                    }
                    Spacer()
                }
            }
            .alert(isPresented: $viewModel.showLoginError){
                Alert(title: Text("Login failed"))
            }
            .alert(isPresented: $viewModel.showBiometricsError){
                Alert(title: Text("Error in face id"))
            }
        } else {
            Button("Unlock", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}



#Preview {
    ContentView()
}
