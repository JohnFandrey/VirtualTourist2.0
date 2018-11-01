//
//  Manipulating Photos.swift
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
    
    // The function checkForPhotos is passed a pin and runs a fetch request.  The fetch request returns an array of photos that are related to the pin that was passed to the function.  If the array contains photos then those photos are passed to the displayPhotosFromDataModel function.  If the array is empty then the download photosFromFlickr() function is called.
    
    func checkForPhotos(pin: Pin) {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin.latitude = %@ && pin.longitude = %@", pin.latitude!, pin.longitude!)
        fetchRequest.predicate = predicate
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            photos = results
            if photos.count != 0 {
                displayPhotosFromDataModel(array: photos)
            } else {
                getNumberOfPages()
            }
        }
    }
    
    // The function displayPhotosFromDataModel is passed an array of Photos.  The function then loops through the array and initializes a cell of type ImageCollectionViewCell.  The cell image is set to the image value of the photo and the cell is added to the cells array.
    
    func displayPhotosFromDataModel(array: [Photo]){
        DispatchQueue.main.async {
            for item in array {
                let cell = ImageCollectionViewCell()
                var image: UIImage!
                var data: Data?
                if let data = item.image {
                    image = UIImage(data: data)
                    cell.image = image
                    self.cells.append(cell)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    // The function addPhotosToDataModel is passed an array of dictionaries.  The array is passed to the createNewArray function which returns only 20 dictionaries.  The limit on dictionaries is there to prevent an excessive amount of items from being retrieved and displayed.  The dictionaries contain a url.  The url is retrieved from each dictionary and passed to the retrieveImageFromURL function.  Once the for loop has completed running then the newCollection button at the bottom of the collection view is enabled.
        
        func addPhotosToDataModel(array: [[String:Any]]) {
            var counter: Int = 0
            if array.count != 0 {
                let newArray = createNewArray(array: array)
                for item in newArray {
                    if counter <= newArray.count - 1 {
                        let originalURL = item["url_m"] as! String
                        let modifiedURL = originalURL.replacingOccurrences(of: "\\", with: "")
                        let url = URL(string: modifiedURL)
                        let photo = Photo(context: dataController.viewContext)
                        photo.url = modifiedURL
                        photo.pin = pin
                        do {
                            try dataController.viewContext.save()
                            retrieveImageFromURL(url: url!, photo: photo, counter: counter)
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                    counter += 1
                }
                DispatchQueue.main.async {
                   self.newCollectionOutlet.isEnabled = true
                }
            }
        }
    
    // The function retrieveImageFromURL is passed a URL, a Photo object, and a counter variable.  The function downloads the image from the received URL and saves the image data to the appropriate pin.  The image data is also saved to the appropirate item in the cells array.
    
    func retrieveImageFromURL(url: URL, photo: Photo, counter: Int) {
        // I found an example for saving an image as a Binary attribute a youtube video at https://www.youtube.com/watch?v=f0IpkDHccTw.  The video is part of a raywenderlich.com tutorial and was posted on December 1, 2017.
        // I also found an example for retrieving an image from a URL at https://www.simplifiedios.net/get-image-from-url-swift-3-tutorial/ in a post by Belal Khan dated July 3, 2017.
        // Udacity has also provided an example for downloading data from the a URL
        // I have used both of the examples above to get data retrieved from Flickr to be stored properly in Core Data.
            let imageURL = url
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if error == nil {
                    let downloadedData = data
                    photo.image = downloadedData
                    if downloadedData != nil && counter <= (self.cells.count - 1) {
                        self.cells[counter].image = UIImage(data: downloadedData!)!
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        do {
                            try self.dataController.viewContext.save()
                            self.photos.append(photo)
                        } catch {
                            print("Unable to save photo.")
                        }
                    }
                }
            }
            task.resume()
    }
    
    // The function populateCellsArray populates an array of type ImageCollectionViewCells.  This is done so that the CollectionView Delegate methods have an array to refer for their data.
    
    func populateCellsArray(photos: [[String:Any]]){
        var counter: Int = 0
        while counter < 20 {
            DispatchQueue.main.async{
                let cell = ImageCollectionViewCell()
                self.cells.append(cell)
            }
            counter += 1
        }
        addPhotosToDataModel(array: photos)
    }
    
    // The function createNewArray receives a dictionary and returns a dictionary that is limited to 20 items.  This is done to limit the number of photos returned.  
    
    func createNewArray(array: [[String:Any]]) -> [[String:Any]]{
        var counter = 0
        var newArray = [[String:Any]]()
        while counter < 20 && counter <= array.count - 1 {
            if array.count >= counter && array.count != 0 {
                newArray.append(array[counter])
                counter += 1
            }
        }
        return newArray
    }
    
}
