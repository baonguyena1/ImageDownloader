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

enum FileStatus {
    case None
    case Queueing
    case Downloading
    case Error
    case Unziping
    case Finished
}

extension FileStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .None:
            return ""
        case .Queueing:
            return "Queueing"
        case .Downloading:
            return "Downloading"
        case .Error:
            return "Error"
        case .Unziping:
            return "Unziping"
        case .Finished:
            return "Finished"
        }
    }
}

enum FileType {
    case ZIP
    case PDF
    case IMAGE
}

extension FileType: CustomStringConvertible {
    var description: String {
        switch self {
        case .ZIP:
            return "zip"
        case .PDF:
            return "pdf"
        case .IMAGE:
            return ""
        }
    }
}
