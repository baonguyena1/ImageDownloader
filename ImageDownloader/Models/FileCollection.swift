//
//  FileContent.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

private var fileCellObservationContext = 0

class FileCollection: NSObject {
    
    
    
    var rootDirectory: String!
    var title: String!
    var status: DownloadStatus
    var photos: [Photo]!
    var overallProgress: Progress?  // Keep reference from list photo in FileCell
    
    init(rootDirectory: String, title: String) {
        self.rootDirectory = rootDirectory
        self.title = title
        self.status = .Queueing
        super.init()
        
        loadJSONData()
    }
    
    // Load URL JSON from json file
    fileprivate func loadJSONData() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("\(self.rootDirectory!)\(self.title!)")
            do {
                let data = try Data(contentsOf: path, options: .alwaysMapped)
                let photoUrls = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String]
                photos = photoUrls.map({ Photo(URL: URL(string: $0)!) })
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    // Start add progress to queue
    func importPhotos() -> Progress {
        let progress = Progress()
        progress.totalUnitCount = Int64(photos.count)
        for photo in photos {
            let importProgress = photo.startImport()
            progress.addChild(importProgress, withPendingUnitCount: 1)
        }
        return progress
    }
    
    func resetPhoto() {
        for photo in photos {
            photo.reset()
        }
        status = .Queueing
    }

}
