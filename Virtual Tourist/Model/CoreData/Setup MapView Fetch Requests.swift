//
//  Setup MapView Fetch Requests.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension MapViewController {
    
    // The function setupLatitudeFetchRequest sets up the latitude fetch request.  The function receives an MKAnnotationView and returns a fetch request.  The function sets up the fetchRequest by taking the latitude of the MKAnnotationView and rounding it to 10 decimal places.  This was done to ensure that the number of decimal places used by the latitude stored in the persistent store match the number of decimal places used in the fetch request.
    
    func setupLatitudeFetchRequest(_ view: MKAnnotationView) -> NSFetchRequest<Pin>{
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        if let latitude = view.annotation?.coordinate.latitude {
            let latitudeString = roundCoordinate(number: latitude)
            let predicate = NSPredicate(format: "latitude == %@", latitudeString)
            fetchRequest.predicate = predicate
            return fetchRequest
        }
        return fetchRequest
    }
    
    // This function works the same way as setupLatitudeFetchRequest above.
    
    func setupLongitudeFetchRequest(_ view: MKAnnotationView) -> NSFetchRequest<Pin>{
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        if let longitude = view.annotation?.coordinate.longitude {
            let longitudeString = roundCoordinate(number: longitude)
            let predicate = NSPredicate(format: "longitude == %@", longitudeString)
            fetchRequest.predicate = predicate
            return fetchRequest
        }
        return fetchRequest
    }
    
    // The function roundCoordinate is passed a Double and returns a string rounded to 10 decimal places.  This is done to ensure that the coordinates stored in the persistent store and the coordinates of the annotation match.
    
    func roundCoordinate(number: Double) -> String {
        return (String(format: "%.10f", number))
    }
    
    // The function checkCoordinates receives two fetch requests and finds a pin that matches the result of both fetch requests.  This function was written with an awareness that there is small probability that two different annotations may have the same latitude or longitude.  The function ensures that pins returned by the fetch request have both the same latitude and the same longitude.  
    
    func checkCoordinates(_ latitudeFetchRequest: NSFetchRequest<Pin>, _ longitudeFetchRequest: NSFetchRequest<Pin>) -> Pin{
        var latitudePin: Pin!
        var longitudePin: Pin!
        do {
            if let result = try? dataController.viewContext.fetch(latitudeFetchRequest){
                latitudePin = result[0]
            }
        }
        
        do {
            if let result = try? dataController.viewContext.fetch(longitudeFetchRequest){
                longitudePin = result[0]
            }
        }
        if latitudePin.latitude == longitudePin.latitude && latitudePin.longitude == longitudePin.longitude {
            return latitudePin
        } else {
            return latitudePin
        }
    }
    
}
