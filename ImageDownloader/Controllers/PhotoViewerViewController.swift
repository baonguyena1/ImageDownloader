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
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setImage(image: UIImage?, index: Int, total: Int) {
        DispatchQueue.main.async {
            self.photoImageView.image = image
            self.totalLabel.text = "\(index)/\(total)"
        }
    }
}
