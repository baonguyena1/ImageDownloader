/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                PhotoImport represents the import operation of a Photo. It combines both the PhotoDownload and PhotoFilter operations.
            
*/

import UIKit

class PhotoImport: NSObject, ProgressReporting {
    // MARK: Properties

    var completionHandler: ((_ data: Data?, _ error: NSError?) -> Void)?

    let progress: Progress

    let download: PhotoDownload

    // MARK: Initializers

    init(URL: URL) {
        progress = Progress()
        /* 
            This progress's children are weighted: The download takes up 90% 
            and the filter takes the remaining portion.
        */
        progress.totalUnitCount = 10

        download = PhotoDownload(URL: URL)
    }

    func start() {
        /*
            Use explicit composition to add the download's progress to ours,
            taking 9/10 units.
        */
        progress.addChild(download.progress, withPendingUnitCount: 9)

        download.completionHandler = { data, error in
            self.callCompletionHandler(data: data, error: error)
        }

        download.start()
    }
    
    fileprivate func callCompletionHandler(data: Data?, error: NSError?) {
        completionHandler?(data, error)
        completionHandler = nil
    }
}
