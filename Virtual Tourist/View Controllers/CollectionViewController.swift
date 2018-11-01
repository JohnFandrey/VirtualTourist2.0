//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/10/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    var downloadedImage = Data()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var newCollectionOutlet: UIBarButtonItem!
    
    @IBAction func getNewPhotos(_ sender: Any) {
        newCollectionOutlet.isEnabled = false
        deletePhotosAndReplace()
    }
    
    var dataController: DataController!
    
    var photos = [Photo]()
    
    var cells = [ImageCollectionViewCell]()
    
    var pin = Pin()
    
    var collectionViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForPhotos(pin: pin)
        centerMapOnLocation()
        if UserDefaults.standard.bool(forKey: "presentCollectionInfo") {
            displayError("Tap on an image to remove it from the collection.  Tap 'New Collection' to remove all the existing photos in the collection and replace them with new ones.  Press the back button in the top left of the screen to return to the map.", self, "Information")
            UserDefaults.standard.set(false, forKey: "presentCollectionInfo")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // The function centerMapOnLocation sets the region and center location for the mapView in the CollectionViewController.
    
    
    func centerMapOnLocation() {
        // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
        // This function sets a coordinateRegion and sets Region for the mapView.
        let regionRadius: CLLocationDistance = 100000
        let location = CLLocation(latitude: pin.maxLatitude, longitude: pin.maxLongitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.maxLatitude
        annotation.coordinate.longitude = pin.maxLongitude
        mapView.addAnnotation(annotation)
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
    }
    
    // The function displayError creates and presents an alert controller that provides error information to the user if called.
    
    func displayError(_ info: String, _ sender: UIViewController, _ title: String = "Error") {         // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        let alertController = UIAlertController(title: title, message: info, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        sender.present(alertController, animated: true, completion: nil)
    }
    
    // The function downloadPhotosFromFlickr calls the appropriate networking code in the FlickrClient and passes a completion handler to those functions.
    
    func getNumberOfPages(){
        FlickrClient.sharedInstance().getNumberOfPages(pin){(data: AnyObject?, error: String?) in
            if error != nil {
                let errorText: String = error!
                DispatchQueue.main.async {
                    self.displayError(errorText, self)
                }
                return
            }
            if data != nil {
                if let sessionData = data as! [String:Any]? {
                    if let status = sessionData["stat"] as! String? {
                        if status == "ok" {
                            let sessionDictionary = sessionData["photos"] as! [String:Any]
                            let pages = sessionDictionary["pages"] as! Int
                            FlickrClient.sharedInstance().numberOfPages = pages
                            self.downloadPhotosFromFlickr()
                        } else {
                            if status == "fail" {
                                if let message = sessionData["message"] as! String? {
                                    print(message)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func downloadPhotosFromFlickr(){
        FlickrClient.sharedInstance().getPhotos(pin){(data: AnyObject?, error: String?) in
            if error != nil {
                let errorText: String = error!
                DispatchQueue.main.async  {
                    self.displayError(errorText, self)
                }
                return
            }
            if data != nil {
                if let sessionData = data as! [String:Any]? {
                    if let status = sessionData["stat"] as! String? {
                        if status == "ok" {
                            let sessionDictionary = sessionData["photos"] as! [String:Any]  // Set a dictionary of type [String:String] equal to sessionData["session"].
                            let photos = sessionDictionary["photo"] as! [[String:Any]]         // Set the sessionID equal to sessionDictionary["id"].
                            self.populateCellsArray(photos: photos)
                        } else {
                            if status == "fail" {
                                if let message = sessionData["message"] as! String? {
                                    print(message)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // The function deletePhotosAndReplace deletes the photos in the photos array, the persistent store, and the deletes the cells in the cells array.  
    
    func deletePhotosAndReplace(){
        for photo in photos {
            dataController.viewContext.delete(photo)
            if photos.count != 0 {
               photos.removeFirst()
                if cells.count != 0 {
                    cells.removeFirst()
                }
            }
        }
        downloadPhotosFromFlickr()
    }

}
