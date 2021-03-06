//
//  QueueSingleton.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

// Define single to manager queue
class QueueSingleton {
    static let operationQueue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 1
       return operation
    }()
}
