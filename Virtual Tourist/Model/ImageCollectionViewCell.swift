//
//  ImageCollectionViewCell.swift
//  VirtualTourist
//
//  Created by JohnFandrey on 7/20/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// The ImageCollectionViewCell class provides a way to connect to outlets in each cell. Specifically, UIImageView and activityView.

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var image: UIImage?
    
}
