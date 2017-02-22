//
//  PhotoCell.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell, CellIdentifiter {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var photo: Photo? {
        didSet {
            photoImageView.image = photo?.image
        }
    }
    
    class func cellId() -> String {
        return "photoCell"
    }
}
