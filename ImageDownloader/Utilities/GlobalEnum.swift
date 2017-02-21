//
//  GlobalEnum.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

enum DownloadStatus {
    case Queueing
    case Downloading
    case Finished
}

extension DownloadStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .Queueing:
            return "Queueing..."
        case .Downloading:
            return "Downloading..."
        case .Finished:
            return "Finished"
        }
    }
}
