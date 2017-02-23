//
//  QueueSingleton.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation



class QueueSingleton {
    static let operationQueue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 4
       return operation
    }()
}
