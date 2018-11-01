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
    var firstPin = Pin()
    var annotations = [MKPointAnnotation]()
    
    // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    // The function centerMapOnLocation sets the center coordinate for the mapView and the coordiante span.  The values for the center coordinate and span are retrieved from UserDefaults.  This is done to persist the last location that the user was viewing.
    
    func centerMapOnLocation() {
        // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
        // This function sets a coordinateRegion and sets Region for the mapView.
        var coordinateRegion: MKCoordinateRegion!
        let location = CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "latitude") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "longitude") as! CLLocationDegrees)
        let span = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.value(forKey: "latitudeDelta") as! CLLocationDegrees, longitudeDelta: UserDefaults.standard.value(forKey: "longitudeDelta") as! CLLocationDegrees)
        coordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // I found code for setting up the gesture recognizer at https://stackoverflow.com/questions/40894722/swift-mkmapview-drop-a-pin-annotation-to-current-location in a post by 'Kevin' dated November 30, 2016.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteMessage.isHidden = true
        mapView.delegate = self
        centerMapOnLocation()
        checkForPins()
        if UserDefaults.standard.bool(forKey: "presentInfo") == true {
            presentInformation(self)
            UserDefaults.standard.set(false, forKey: "presentInfo")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMapView()
    }
    
    // The function presentInfo creates and presents an alert controller that provides information to the user if called.
    
    func presentInformation(_ sender: UIViewController) {         // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        let alertController = UIAlertController(title: "Information", message: "Press and hold on the map at a single location for one second to drop a pin there.  Tap on a pin to view photos from that area.  To delete pins tap 'Edit' in the top right corner and then tap the pins you want to delete.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        sender.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        displayDeleteMessage()  // Will display or hide the delete message depending on the state of the 'Edit' button.
    }
    
    @IBOutlet var longpressOutlet: UILongPressGestureRecognizer!
    
    // The function longpressAction is called when the user presses on a single point on the mapView for one seconds or more. 
    
    @IBAction func longpressAction(_ sender: Any) {
    // I found an example using a LongPressGestureRecognizer online at https://www.ioscreator.com/tutorials/long-press-gesture-ios-tutorial-ios11 in a post by Arthur Knopper dated August 24, 2017.  Arthur's example provided me with the idea for using the .state == .began.
        
        
        if longpressOutlet.state == .began {
            let touchLocation = longpressOutlet.location(in: self.mapView) // adds the location on the view it was pressed
            
            // I found an example for converting the location of the touch to a latitude and longitude coordinate at https://medium.com/@williamliu_19785/drawing-on-mkmapview-daceab966177 in a post by William Liu dated March 13, 2017.
            
            let touchLocationCoordinate : CLLocationCoordinate2D = mapView.convert(touchLocation, toCoordinateFrom: self.mapView) // will get coordinates
            let additionalPin = MKPointAnnotation() // Creates an instance of MKPointAnnotation.
            additionalPin.coordinate = touchLocationCoordinate // Sets the coordinates of 'additionalPin' to the coorindates of the points touched on the map.
            addPin(annotation: additionalPin) // Calls the addPin function with the additionalPin.  
        }
    }
    
}


