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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: UIBarButtonItem) {
        guard let filesTable = filesTableViewController else {
            return
        }
        for file in filesTable.fileContents {
            file.resetPhoto()
        }
        filesTable.fileContents.removeAll()
        filesTable.tableView.reloadData()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        guard let filesTable = filesTableViewController else {
            return
        }
        filesTable.loadZipfile()
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filesTableViewController = segue.destination as? FilesTableViewController {
            self.filesTableViewController = filesTableViewController
        }
    }
 

}
