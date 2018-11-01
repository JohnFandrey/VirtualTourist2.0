//
//  CollectionView Delegate Methods.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension CollectionViewController {
    
    // I used code provided by Udacity for the Bond Villains app to set up the delegate methods for the collection view controller.  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    // The delegate method below is called when the collection view data is reloaded.
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            // I found a webiste, https://www.ralfebert.de/ios-examples/uikit/swift-uicolor-picker/, that provides the RGB and alpha values for a UI color selected from a palette.  I used this site to set the cell background color to blue.
                    cell.activityView.isHidden = false // Reveals the activity view when the cell is updating.
                    cell.activityView.startAnimating() // Animates the activity view when the cell is updating.
                    cell.backgroundColor = UIColor.blue // Changes the cell background to blue so that there is a placeholder while the new image is downloading.
                if self.cells[indexPath.row].image != nil {
                    cell.imageView.image = self.cells[indexPath.row].image // Once the image is no longer nil the cell displays the downloaded image.
                    cell.activityView.stopAnimating() // The activity view stops animating.
                    cell.activityView.isHidden = true // The activity view is hidden.
                    cell.backgroundColor = UIColor.white // The cell background changes to white.
                }
        return cell
    }
    
    // The delegate method below is called when a cell is selected.
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        if indexPath.row <= (photos.count - 1) {
            let photoToDelete: Photo = photos[indexPath.row] // Sets the photo to delete as the item in the photos array at the indexPath.row.
            photos.remove(at: indexPath.row) // Removes a photo from the photos array.
            cells.remove(at: indexPath.row) // Removes a cell from the cells array.
            dataController.viewContext.delete(photoToDelete) // Deletes the photo from the viewContext.
            collectionView.reloadData() // Reloads the collection view data.
        }
        return
    }
    
    // The delegate method below is for the mapView in the collectionView view controller. // I used the PinSample App provided by Udacity and the Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.  The post for the Ray Wenderlich tutorial was updated on June 27, 2017 and can be found at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.
    
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.animatesDrop = false
        }
        return view
    }
    
}
