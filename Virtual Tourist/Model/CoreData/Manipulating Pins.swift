//
//  Retrieving Pins.swift
//  VirtualTourist
//
//  Created by JohnFandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension MapViewController {
    
    // The function 'addPin' is passed an MKPointAnnotation and then creates and saves a Pin based on the passed MKPointAnnotation.
    
    func addPin(annotation: MKPointAnnotation) {
        let pin = Pin(context: dataController.viewContext) // Initializes a value pin.
        pin.latitude = roundCoordinate(number: annotation.coordinate.latitude)  // Sets the latitude as a string, but first rounds the latitude to 10 decimal places.
        pin.longitude = roundCoordinate(number: annotation.coordinate.longitude) // Sets the longitude as a string, but first rounds the latitude to 10 decimal places.
        pin.maxLatitude = calculateMaxAndMin(type: "lat", degrees: annotation.coordinate.latitude).1 // Sets the maxlatitude
        pin.minLatitude = calculateMaxAndMin(type: "lat", degrees: annotation.coordinate.latitude).0 // Sets the minLatitude
        pin.maxLongitude = calculateMaxAndMin(type: "lon", degrees: annotation.coordinate.longitude).1 // Sets the maxLongitude
        pin.minLongitude = calculateMaxAndMin(type: "lon", degrees: annotation.coordinate.longitude).0 // Sets the minLongitude.
        do {
            try dataController.viewContext.save()  // Saves the pin with its set attributes.
        }
        catch {
            print(error.localizedDescription)
        }
        pins.append(pin)        // Adds a pin to the pins array.
        mapView.addAnnotation(annotation) // Adds an annotation to mapView.
        annotations.append(annotation)   // Adds an annotation to the annotations array.
    }
    
    // The function calculateMaxAndMin is used to ensure that the bounding box used by flickr to set the area where photos will be taken from does not go outside the maximum or minimum acceptable bounds for values of latitude and longitude.
    
    func calculateMaxAndMin(type: String, degrees: CLLocationDegrees) -> (Double, Double){
        var minimum: Double = degrees - 0.05
        var maximum: Double = degrees + 0.05
        if type == "lat" {
            if minimum < -90 {
                minimum = -90
            }
            if maximum > 90 {
                maximum = 90
            }
        }
        if type == "lon" {
            if minimum < -180 {
                minimum = -180
            }
            if maximum > 180 {
                maximum = 180
            }
        }
        return (minimum, maximum)
    }
    
    
    // The function removePinFromArray is passed a Pin.  The function then loops through the pins array searches for a Pin that matches the Pin that was passed in at the function call.  Once a match is found the counter is used to remove the pin at the correct index.
    
    func removePinFromArray(_ pinToDelete: Pin) {
        var counter: Int = 0
        for pin in pins {
            if pin == pinToDelete {
                pins.remove(at: counter)
                return
            } else {
                counter += 1
            }
        }
    }
    
    // The function removeAnnotation is passed an MKPointAnnotation.  The function searches the annotations array for an annotation that matches the passed MKPointAnnotation.  Once a match is found the counter variable is used to remove the correct annotation from the annotations array.
    
    func removeAnnotation(_ annotationToRemove: MKPointAnnotation) {
        var counter: Int = 0
        for annotation in annotations {
            if annotation == annotationToRemove {
                annotations.remove(at: counter)
            } else {
                counter += 1
            }
        }
    }
    
    // The function checkForPins uses a fetch request to search for Pins in the persistent store.  If pins are found then the pins array is populated with the pins retrieved from the persistent store.  The pins array is then passed to the annotations array function.
    
    func checkForPins() {
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            pins = results
            if results.count != 0 {
                firstPin = results[0]
                addAnnotations(pins)
            }
        }
    }
    
    // The function deletePin is passed an MKAnnotationView.  The function then uses that view to fetch a pin with a latitude and longitude that matches the latitude and longitude of the MKAnnotationView received by the function.  If a match is found then the pin is removed from the pins array and the annoation is removed from the map.
    
    func deletePin(_ view: MKAnnotationView) {
        var pinToDelete: Pin!
        let latitudeFetchRequest = setupLatitudeFetchRequest(view)
        let longitudeFetchRequest = setupLongitudeFetchRequest(view)
        pinToDelete = checkCoordinates(latitudeFetchRequest, longitudeFetchRequest)
        removePinFromArray(pinToDelete)
        let annotation = view.annotation as! MKPointAnnotation
        removeAnnotation(annotation)
        mapView.removeAnnotation(annotation)
        dataController.viewContext.delete(pinToDelete)
        try? dataController.viewContext.save()
    }
    
}
