/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                Photo represents an image that can be imported.
            
*/

import UIKit

class Photo: NSObject {
    // MARK: Properties

    let imageURL: URL
    
    /// Marked "dynamic" so it is KVO observable.
    dynamic var image: UIImage?
    
    /// The photoImport is KVO observable for its progress.
    dynamic var photoImport: PhotoImport?
    
    var status: FileStatus!
    
    // MARK: Initializers

    init(URL: Foundation.URL) {
        imageURL = (URL as NSURL).copy() as! Foundation.URL
        
        image = grayImage
        status = .Queueing
    }
    
    /// Kick off the import
    func startImport() -> Progress {
        let newImport = PhotoImport(URL: imageURL)
        newImport.completionHandler = { image, error in
            if let image = image {
                // The import is finished. Set our image to the result
                self.image = image
                self.status = .Finished
            }
            else if let error = error {
                self.reportError(error)
                self.status = .Error
            }
            
            self.photoImport = nil
        }
        
        let block = BlockOperation {
            self.status = .Downloading
            newImport.start()
        }
        QueueSingleton.operationQueue.addOperation(block)
        photoImport = newImport
        
        return newImport.progress
    }
    
    fileprivate func reportError(_ error: NSError) {
        if error.domain != NSCocoaErrorDomain || error.code != NSUserCancelledError {
            print("Error importing photo: \(error.localizedDescription)")
        }
    }
    
    /// Go back to the initial state.
    func reset() {
        image = grayImage
        photoImport = nil
    }
}
