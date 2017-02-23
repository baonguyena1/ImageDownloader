/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                Photo represents an image that can be imported.
            
*/

import UIKit
import SSZipArchive

class Photo: NSObject {
    // MARK: Properties

    let imageURL: URL
    
    /// Marked "dynamic" so it is KVO observable.
    dynamic var image: UIImage?
    
    /// The photoImport is KVO observable for its progress.
    dynamic var photoImport: PhotoImport?
    
    var status: FileStatus!
    
    // MARK: Initializers

    init(URL: URL) {
        imageURL = (URL as NSURL).copy() as! URL
        image = grayImage
        status = .None
    }
    
    /// Kick off the import
    func startImport() -> Progress {
        let newImport = PhotoImport(URL: imageURL)
        // Handle result after download
        newImport.completionHandler = { data, error in
            self.photoImport = nil
            if let error = error {
                self.reportError(error)
                self.status = .Error
            } else if let data = data {
                let urlString = self.imageURL.absoluteString.components(separatedBy: ".").last
                switch urlString!.lowercased() {
                case FileType.ZIP.description:
                    self.status = .Unziping
                    self.unzipFileAndGetImage(data: data, error: error)
                case FileType.ZIP.description:
                    self.convertPDFtoImage(data: data, error: error)
                default:
                    guard let image = UIImage(data: data as Data) else {
                        self.status = .Error
                        return
                    }
                    self.image = image
                    self.status = .Finished
                }
            }
        }
        //Add block to singleton queue
        let block = BlockOperation {
            self.status = .Downloading
            newImport.start()
        }
        
        QueueSingleton.operationQueue.addOperation(block)
        photoImport = newImport
        status = .Queueing
        return newImport.progress
    }
    
    fileprivate func reportError(_ error: NSError) {
        if error.domain != NSCocoaErrorDomain || error.code != NSUserCancelledError {
            print("Error importing photo: \(error.localizedDescription)")
        }
    }
    
    fileprivate func unzipFileAndGetImage(data: Data, error: NSError?) {
        print("Unzip file")
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let saveFileLocation = UUID().uuidString
            let extractFileLocation = UUID().uuidString
            let fromPath = dir.appendingPathComponent(saveFileLocation)
            let toPath = dir.appendingPathComponent(extractFileLocation)
            var filename: String?
            //writing to directory
            do {
                try data.write(to: fromPath)
                SSZipArchive.unzipFile(atPath: fromPath.path, toDestination: toPath.path, progressHandler: { (filepath, fileinfo, readByte, totalByte) in
                    if filename == nil {
                        filename = filepath
                    }
                }, completionHandler: { (filelocation, success, err) in
                    if (success) {
                        // Get image after extract
                        print("Get image after extract")
                        var relativepath = extractFileLocation
                        if let filename = filename {
                            relativepath = relativepath.appending("/\(filename)")
                        }
                        let imageUrl = dir.appendingPathComponent(relativepath)
                        do {
                            let imageData = try Data(contentsOf: imageUrl)
                            if let image = UIImage(data: imageData) {
                                self.updateImage(image: image, status: .Finished)
                            } else {
                                self.updateImage(image: nil, status: .Error)
                            }
                        } catch {
                            self.updateImage(image: nil, status: .Error)
                        }
                    }
                })
                
            } catch (let err) {
                print("Error: \(err.localizedDescription)")
            }
        }
    }
    
    fileprivate func convertPDFtoImage(data: Data, error: NSError?) {
        print("Convert pdf file to image")
        let pdfData = data as CFData
        guard let provider = CGDataProvider(data: pdfData), let document = CGPDFDocument(provider), let page = document.page(at: 1) else {
            updateImage(image: nil, status: .Error)
            return
        }
        
        let pageRect = page.getBoxRect(.mediaBox)
        if #available(iOS 10.0, *) {
            print("iOS 10.0")
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)
                
                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0);
                ctx.cgContext.drawPDFPage(page);
            }
            updateImage(image: img, status: .Finished)
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContext(pageRect.size)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(page)
            context.restoreGState()
            let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            updateImage(image: pdfImage, status: .Finished)
        }
    }
    
    fileprivate func updateImage(image: UIImage?, status: FileStatus) {
        if let image = image {
            self.image = image
        }
        self.status = status
    }
    
    /// Go back to the initial state.
    func reset() {
        image = grayImage
        photoImport = nil
    }
}
