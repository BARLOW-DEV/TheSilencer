//
//  LocationNotificationInfo.swift
//  LocationNotifier
//
//  Created by Mian Miftah on 4/20/2021.
//

import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates 
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
