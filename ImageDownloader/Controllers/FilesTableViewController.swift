//
//  FilesTableViewController.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SSZipArchive

class FilesTableViewController: UITableViewController, SSZipArchiveDelegate {
    
    fileprivate let urlString = "https://dl.dropboxusercontent.com/u/4529715/JSON%20files%20updated.zip"
    fileprivate var folderDestination: String?
    
    fileprivate var filenames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadZipfile(urlString: urlString) {
            
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filenames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.cellId(), for: indexPath) as! FileCell

        cell.titleLabel.text = filenames[indexPath.row]

        return cell
    }
    
    //MARK: download zip file
    fileprivate func loadZipfile(urlString: String, completion: @escaping () -> ()) {
        let url = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let error =  error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let saveFileLocation = UUID().uuidString
                    let extractFileLocation = UUID().uuidString
                    let fromPath = dir.appendingPathComponent(saveFileLocation)
                    let toPath = dir.appendingPathComponent(extractFileLocation)
                    var folderName: String?
                    //writing to directory
                    do {
                        try data.write(to: fromPath)
                        SSZipArchive.unzipFile(atPath: fromPath.path, toDestination: toPath.path, progressHandler: { (filepath, fileinfo, readByte, totalByte) in
                            if folderName == nil {
                                folderName = filepath
                            }
                        }, completionHandler: { (filelocation, success, error) in
                            if (success) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                    var relativepath = extractFileLocation
                                    if let folderName = folderName {
                                        relativepath = relativepath.appending("/\(folderName)")
                                    }
                                    _ = self.getListsFile(at: relativepath)
                                })
                            }
                        })
                        
                    } catch (let err) {
                        print("Error: \(err.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
    
    fileprivate func getListsFile(at location: String) {
        print("LISTING ALL FILES FOUND location = \(location)");
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(location)
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(atPath: path.path)
                
                // if you want to filter the directory contents you can do like this:
                let files = directoryContents.filter({ $0.components(separatedBy: ".").last == "json" })
                filenames = files
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
    }
    
    //MARK:
    func zipArchiveDidUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String, unzippedFilePath: String) {
        if folderDestination == nil {
            folderDestination = unzippedFilePath
        }
        
        if fileIndex + 1 == totalFiles {
            getListsFile(at: folderDestination ?? "")
        }
    }
}
