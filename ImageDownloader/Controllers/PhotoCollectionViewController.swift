//
//  PhotoCollectionViewController.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var fileCollection: FileCollection? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var forceReloadHandler: (()->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func reload(_ sender: UIBarButtonItem) {
        QueueSingleton.operationQueue.cancelAllOperations()
        fileCollection?.resetPhoto()
        self.collectionView?.reloadData()
        fileCollection?.overallProgress = nil
        forceReloadHandler()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previewController = segue.destination as? PhotoViewerViewController {
            let row = self.collectionView?.indexPathsForSelectedItems?.first?.row
            let photo = fileCollection?.photos[row!]
            previewController.setImage(image: photo?.image, index: row! + 1, total: fileCollection?.photos.count ?? 0)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileCollection?.photos.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellId(), for: indexPath) as! PhotoCell
    
        cell.photo = fileCollection?.photos[indexPath.row]
    
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 4 - 2*3)/4.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

}
