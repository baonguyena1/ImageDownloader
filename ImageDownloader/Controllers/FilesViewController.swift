//
//  FilesViewController.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController {
    
    @IBOutlet var resetBarButton: UIBarButtonItem!
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var pauseBarButton: UIBarButtonItem!
    weak var filesTableViewController: FilesTableViewController?
    
    var isPause =  true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func reset(_ sender: UIBarButtonItem) {
        guard let filesTableViewController = filesTableViewController else {
            return
        }
        QueueSingleton.operationQueue.cancelAllOperations()
        for file in filesTableViewController.fileCollections {
            file.resetPhoto()
        }
        filesTableViewController.fileCollections.removeAll()
        filesTableViewController.tableView.reloadData()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        guard let filesTableViewController = filesTableViewController else {
            return
        }
        filesTableViewController.loadZipfile()
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        guard let filesTableViewController = filesTableViewController else {
            return
        }
        isPause = !isPause
        pauseBarButton.title = isPause ? "Pause" : "Resume  "
        for fileContent in filesTableViewController.fileCollections {
            isPause ? fileContent.overallProgress?.resume() : fileContent.overallProgress?.pause()
        }
    }

    @IBAction func changeConcurrentNumber(_ sender: UISlider) {
        QueueSingleton.operationQueue.maxConcurrentOperationCount = Int(sender.value)
        print("maxConcurrentOperationCount = \(QueueSingleton.operationQueue.maxConcurrentOperationCount)")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filesTableViewController = segue.destination as? FilesTableViewController {
            self.filesTableViewController = filesTableViewController
        }
    }
 

}
