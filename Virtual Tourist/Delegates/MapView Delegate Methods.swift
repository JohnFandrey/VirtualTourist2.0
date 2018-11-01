//
//  MapView Delegate Methods.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        pinTap(view: view)
    }
    
    // I used the PinSample App provided by Udacity and a Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.  The post for the Ray Wenderlich tutorial was updated on June 27, 2017 and can be found at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.
    
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
    
    // The delegate method below updates the UserDefaults every time the map region changes.  This is done so that the user's last position on the map is persisted.  
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UserDefaults.standard.set(mapView.centerCoordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(mapView.centerCoordinate.longitude, forKey: "longitude")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDelta")
        UserDefaults.standard.synchronize()
    }

}
