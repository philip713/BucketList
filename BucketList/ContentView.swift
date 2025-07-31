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
    @State private var isUnlocked = false
    var body: some View {
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
    }
    
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            let reason = "We need to unlock your data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                if success{
                    isUnlocked = true
                } else {
                    //problem
                }
            }
        } else {
            //no biometrics
        }
    }
}



#Preview {
    ContentView()
}
