/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                PhotoImport represents the import operation of a Photo. It combines both the PhotoDownload and PhotoFilter operations.
            
*/

import UIKit
import SSZipArchive

class PhotoImport: NSObject, ProgressReporting {
    // MARK: Properties

    var completionHandler: ((_ image: UIImage?, _ error: NSError?) -> Void)?

    let progress: Progress

    let download: PhotoDownload

    // MARK: Initializers

    init(URL: Foundation.URL) {
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
            guard let contentData = data else {
                self.callCompletionHandler(image: nil, error: error)
                return
            }
            
            let urlString = self.download.downloadURL.absoluteString.components(separatedBy: ".").last
            switch urlString!.lowercased() {
            case "zip":
                self.unzipFileAndGetImage(data: contentData, error: error)
            case "pdf":
                self.convertPDFtoImage(data: contentData, error: error)
            default:
                guard let image = UIImage(data: contentData as Data) else {
                    self.callCompletionHandler(image: nil, error: error)
                    return
                }
                
                /*
                 Make self.progress the currentProgress. Since the filteredImage
                 supports implicit progress reporting, it will add its progress
                 to ours.
                 */
                self.progress.becomeCurrent(withPendingUnitCount: 1)
                let filteredImage = PhotoFilter.filteredImage(image)
                self.progress.resignCurrent()
                
                self.callCompletionHandler(image: filteredImage, error: nil)
            }
            
        }

        download.start()
    }
    
    fileprivate func callCompletionHandler(image: UIImage?, error: NSError?) {
        completionHandler?(image, error)
        completionHandler = nil
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
                                self.callCompletionHandler(image: image, error: nil)
                            } else {
                                self.callCompletionHandler(image: nil, error: error)
                            }
                        } catch let error {
                            self.callCompletionHandler(image: nil, error: error as NSError?)
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
            self.callCompletionHandler(image: nil, error: error)
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
            self.callCompletionHandler(image: img, error: error)
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
            self.callCompletionHandler(image: pdfImage, error: error)
        }
    }
}
