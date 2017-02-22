//
//  PhotoViewerViewController.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
