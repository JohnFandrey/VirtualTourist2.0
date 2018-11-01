//
//  Mapview UI Updates.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension MapViewController {
    
    // This function takes a Double value for the latitude and a Double value for the longitude and returns an MKPointAnnotation that can be displayed on the map.
   
    func createAnnotation(latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        return annotation
    }
    
    // This function takes an MKAnnotationView and removes it from the mapView.  The updates are performed on the Main Queue because they are UI updates.
    
    func removePinFromMap(_ view: MKAnnotationView) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotation(view.annotation!)
        }
    }
    
    // This function is called when the edit button in the top left corner of the app is pressed.  If the edit button label reads "Edit" when the view is pressed then the view moves upward and a delete message is displayed at the bottom of the screen.  If the edit button reads "Done" when it is pressed then the view moves back down and the delete message is no longer visible.
    
    func displayDeleteMessage() {
        if editButton.title == "Edit" {
            DispatchQueue.main.async
                {
                    self.deleteMessage.isHidden = false
                    self.editButton.title = "Done"
                    self.mapView.frame.origin.y -= self.deleteMessage.frame.height
            }
        } else {
            DispatchQueue.main.async {
                self.deleteMessage.isHidden = true
                self.editButton.title = "Edit"
                self.mapView.frame.origin.y += self.deleteMessage.frame.height
            }
        }
    }
    
    // This function takes an array of pins and creates an annotation for each pin in the array and appends it to an array of annotations.  Once an annotation has been created for each pin then the app calls the updateMapView function to update the mapView.
    
    func addAnnotations(_ pins: [Pin]){
        for pin in pins {
            // I found an example for converting a string to a double at https://www.hackingwithswift.com/example-code/language/how-to-convert-a-string-to-a-double in a post by Paul Hudson dated September 15th, 2016.
            let doubleLatitude: Double = (pin.latitude! as NSString).doubleValue
            let doubleLongitude: Double = (pin.longitude! as NSString).doubleValue
            let annotation = createAnnotation(latitude: doubleLatitude, longitude: doubleLongitude)
            annotations.append(annotation)
        }
        updateMapView()
    }
    
    // This function removes all the existing annotations on the map and then adds annotations for each value in the annotations array.
    
    func updateMapView(){
        let mapAnnotations = mapView.annotations
        DispatchQueue.main.async {
                self.mapView.removeAnnotations(mapAnnotations) // removes all existing map annotations
                self.mapView.addAnnotations(self.annotations) // adds annotation in the annotations array
            }
        }
    
    // This function is called by the mapView's didSelect annotation delegate method.  This function either displays a collection view for the tapped pin or deletes it depending on the state of the 'Edit' button.
    
    func pinTap(view: MKAnnotationView) {
        if editButton.title == "Edit" {
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
            // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
            newView.dataController = dataController
            newView.pin = pinToPass(view: view)
            newView.collectionViewController = newView
            show(newView, sender: self)
        }
        if editButton.title == "Done" {
            deletePin(view)
            return
        }
    }
    
    // This function fetches the correct pin based on the annotation that was tapped.  The function returns the pin with a latitude and longitude that matches the tapped pin.
    
    func pinToPass(view: MKAnnotationView) -> Pin {
        let latitudeFetchRequest = setupLatitudeFetchRequest(view)
        let longitudeFetchRequest = setupLongitudeFetchRequest(view)
        let pinToPass = checkCoordinates(latitudeFetchRequest, longitudeFetchRequest) // Creates a constant pinToPass and sets it equal to the value returned by the function checkCoordinates.
        return pinToPass // returns pinToPass.
    }
    
}
