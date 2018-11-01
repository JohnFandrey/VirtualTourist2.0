//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/6/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteMessage: UILabel!
    
    var dataController: DataController!
    var pins = [Pin]()
    
 /*   func createAnnotations(){
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            // keep going with this.  Set up the array of annotations and then look at OnTheMap to figure out how that array gets loaded up into the view.
        }
    }
 
 */
    
    // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    let regionRadius: CLLocationDistance = 5000000  // Sets a region radius
    
    func centerMapOnLocation() {
        // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
        // This function sets a coordinateRegion and sets Region for the mapView.
        let location = CLLocation(latitude: 39.00, longitude: -95.00)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // I found code for setting up the gesture recognizer at https://stackoverflow.com/questions/40894722/swift-mkmapview-drop-a-pin-annotation-to-current-location in a post by 'Kevin' dated November 30, 2016.
    
   /*
     func addGestureRecognizer(){
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mapLongPress(_:)))
        longpressGestureRecognizer.minimumPressDuration = 3
        longpressGestureRecognizer.isEnabled = true
        longpressGestureRecognizer.numberOfTouchesRequired = 1
        longpressGestureRecognizer.numberOfTapsRequired = 1
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(longpressGestureRecognizer)
    }
 
 */
    
    func pinTap(view: MKAnnotationView) {
        if editButton.title == "Edit" {
           let newView = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController")
            // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
            show(newView!, sender: self)
        }
        if editButton.title == "Done" {
            print("I'm trying to remove an annotation.")
            deletePin(view)
            return
        }
    }
    
    func deletePin(_ view: MKAnnotationView) {
        var pinsToDelete = [Pin]()
        let fetchRequest = NSFetchRequest<Pin>()
        let predicate = NSPredicate(format: "annotation = %@", view)
        fetchRequest.predicate = predicate
        
        do {
            if let result = try dataController.viewContext.fetch(fetchRequest) as? [Pin] {
                pinsToDelete = result
            }
        } catch {
                fatalError("There was an error fetching the pin.")
            }
        print(pinsToDelete.count)
        dataController.viewContext.delete(pinsToDelete[0])
        mapView.removeAnnotation(view.annotation!)
        removePinFromArray(view)
    }
    
    func removePinFromArray(_ view: MKAnnotationView){
        var counter = 0
        for pin in pins {
            if pin.annotation as! MKPointAnnotation == view.annotation as! MKPointAnnotation {
                print("I found the one.")
                pins.remove(at: counter)
                return
            }
            counter += 1
            print(counter)
        }
    }
    
    // Need to get delete function to remove single pin only.  Also update map view.  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteMessage.isHidden = true
        mapView.delegate = self
        centerMapOnLocation()
        checkForPins()
    }
    
    func checkForPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            pins = results
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func displayDeleteMessage() {
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
       pinTap(view: view)
    }
    
    // I used the PinSample App provided by Udacity and the Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.
    
    
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // I used the PinSample App and the Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.animatesDrop = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
 /*   func addTapGestureRecognizer(){
        //Need comments for source of this code.  https://stackoverflow.com/questions/29720537/removing-pin-annotation-issue-in-mkmapview-swift
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pinTap(view:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        mapView.addGestureRecognizer(tapGesture)
    }
 
 */
 
    
    @IBAction func editButtonPressed(_ sender: Any) {
        displayDeleteMessage()
    }
    
    @IBOutlet var longpressOutlet: UILongPressGestureRecognizer!
    
    @IBAction func longpressAction(_ sender: Any) {
        //need commments for source of this code
        if longpressOutlet.state == .began {
            print("A long press has been detected.")
            let touchLocation = longpressOutlet.location(in: self.mapView) // adds the location on the view it was pressed
            let touchLocationCoordinate : CLLocationCoordinate2D = mapView.convert(touchLocation, toCoordinateFrom: self.mapView) // will get coordinates
            let additionalPin = MKPointAnnotation()
            additionalPin.coordinate = touchLocationCoordinate
            addPin(annotation: additionalPin)
        }
    }
    
    func addPin(annotation: MKPointAnnotation) {
        let pin = Pin(context: dataController.viewContext)
            pin.latitude = annotation.coordinate.latitude
            pin.longitude = annotation.coordinate.longitude
            pin.maxLatitude = calculateMaxAndMin(type: "lat", degrees: pin.latitude).1
            pin.minLatitude = calculateMaxAndMin(type: "lat", degrees: pin.latitude).0
            pin.maxLongitude = calculateMaxAndMin(type: "lon", degrees: pin.longitude).1
            pin.minLongitude = calculateMaxAndMin(type: "lon", degrees: pin.longitude).0
        print("I'm going to try to save.")
        // I'm going to have the delete function operate off of the latitude and longitude.  It will delete pins by searching the persistent store for pins that have the same latitude and longitude as the tapped pin.
        try? dataController.viewContext.save()
        pins.append(pin)
        mapView.addAnnotation(annotation as! MKPointAnnotation)
    }
    
    // I found this code at http://www.globalnerdy.com/2016/01/26/better-to-be-roughly-right-than-precisely-wrong-rounding-numbers-with-swift/ in a post by
    
    func round(_ value: Double, toNearest: Double) -> Double {
        return round(value / toNearest) * toNearest
    }
    
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
    
    func deletePin(pin: Pin) {
        let pinToDelete = pin
        mapView.removeAnnotation(pinToDelete.annotation as! MKAnnotation)
        dataController.viewContext.delete(pinToDelete)
        try? dataController.viewContext.save()
    }
    
}


