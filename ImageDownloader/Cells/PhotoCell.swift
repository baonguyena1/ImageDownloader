//
//  PhotoCell.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

private var photoCellObservationContext = 0

class PhotoCell: UICollectionViewCell, CellIdentifiter {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    fileprivate let fractionCompletedKeyPath = "photoImport.progress.fractionCompleted"
    
    fileprivate let imageKeyPath = "image"
    
    var photo: Photo? {
        willSet {
            if let formerPhoto = photo {
                formerPhoto.removeObserver(self, forKeyPath: fractionCompletedKeyPath, context: &photoCellObservationContext)
                formerPhoto.removeObserver(self, forKeyPath: imageKeyPath, context: &photoCellObservationContext)
            }
        }
        
        didSet {
            if let newPhoto = photo {
                newPhoto.addObserver(self, forKeyPath: fractionCompletedKeyPath, options: [], context: &photoCellObservationContext)
                newPhoto.addObserver(self, forKeyPath: imageKeyPath, options: [], context: &photoCellObservationContext)
            }
            
            updateImageView()
            updateStatus()
        }
    }
    
    fileprivate func updateStatus() {
        if let photoImport = photo?.photoImport {
            let fraction = Float(photoImport.progress.fractionCompleted)
            if (photo?.fileStatus == FileStatus.Downloading) {
                statusLabel.text = (photo?.fileStatus.description ?? "") + String(format: "% 2.0f%%", fraction * 100)
            } else {
                statusLabel.text = photo?.fileStatus.description
            }
        } else {
            statusLabel.text = photo?.fileStatus.description
        }
    }

    fileprivate func updateImageView() {
        UIView.transition(with: photoImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.photoImageView.image = self.photo?.image
        }, completion: nil)
    }
    
    // MARK: Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &photoCellObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        OperationQueue.main.addOperation {
            if keyPath == self.fractionCompletedKeyPath {
                self.updateStatus()
            }
            else if keyPath == self.imageKeyPath {
                self.updateImageView()
            }
        }
    }

    
    class func cellId() -> String {
        return "photoCell"
    }
}