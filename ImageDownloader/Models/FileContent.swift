//
//  FileContent.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SSZipArchive

class FileContent: NSObject {
    
    var rootDirectory: String!
    var title: String!
    var subtitle: DownloadStatus
    var percentComplete: Float
    var photos: [Photo]!
    
    init(rootDirectory: String, title: String) {
        self.rootDirectory = rootDirectory
        self.title = title
        self.subtitle = DownloadStatus.Queueing
        self.percentComplete = 0.0
        super.init()
        
        loadPhotoUrl()
    }
    
    fileprivate func loadPhotoUrl() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("\(self.rootDirectory!)\(self.title!)")
            do {
                let data = try Data(contentsOf: path, options: .alwaysMapped)
                let photoUrls = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String]
                photos = photoUrls.map({ Photo(URL: URL(string: $0)!) })
                // auto Download photo
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func importPhotos() -> Progress {
        let progress = Progress()
//        progress.totalUnitCount = Int64(photos.count)
        progress.totalUnitCount = Int64(1)
        
//        for photo in photos {
//            let importProgress = photo.startImport()
//            
//            progress.addChild(importProgress, withPendingUnitCount: 1)
//        }
        let photo = photos.first
        let importProgress = photo!.startImport()
        
        progress.addChild(importProgress, withPendingUnitCount: 1)
        
        return progress
    }
    
    func resetPhoto() {
        for photo in photos {
            photo.reset()
        }
    }

}
