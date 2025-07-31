//
//  Location.swift
//  BucketList
//
//  Created by Philip Janzel Paradeza on 2025-07-28.
//
import Foundation
import MapKit
struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    static let example = Location(id: UUID(), name: "buckingham", description: "lit by 40000 lightbukbs", latitude: 51.501, longitude: -0.141)
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
