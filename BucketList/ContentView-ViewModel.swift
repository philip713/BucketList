//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Philip Janzel Paradeza on 2025-07-30.
//

import Foundation
import MapKit
import CoreLocation
import LocalAuthentication

extension ContentView{
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var isUnlocked = false
        var showLoginError = false
        var showBiometricsError = false
        init() {
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        func addLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        func update(location: Location){
            guard let selectedPlace else {return}
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save(){
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("unable to dave data")
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself tyo unlock"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){success, authenticationError in
                    if success{
                        self.showLoginError = false
                        self.showBiometricsError = false
                        self.isUnlocked = true
                    }  else {
                        self.showLoginError = true
                    }
                }
            } else {
                self.showBiometricsError = true
            }
        }
    }
}
