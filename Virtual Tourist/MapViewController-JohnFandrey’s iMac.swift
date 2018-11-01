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

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var deleteMessage: UILabel!
    
    // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    let regionRadius: CLLocationDistance = 5000000  // Sets a region radius
    
    func centerMapOnLocation() {
        // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
        // This function sets a coordinateRegion and sets Region for the mapView.
        var location = CLLocation(latitude: 39.00, longitude: -95.00)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteMessage.isHidden = true
        mapView.delegate = self
        centerMapOnLocation()
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
        displayDeleteMessage()
    }
    
    
}

