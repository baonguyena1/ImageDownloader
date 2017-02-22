//
//  FileCell.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

private var fileCellObservationContext = 0

class FileCell: UITableViewCell, CellIdentifiter {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    /// Keys that we observe on `overallProgress`.
    fileprivate let overalProgressObservedKeys = [
        "fractionCompleted",
        "completedUnitCount",
        "totalUnitCount",
        "cancelled",
        "paused"
    ]
    
    fileprivate let fractionCompletedKeyPath = "photoImport.progress.fractionCompleted"
    
    fileprivate let imageKeyPath = "image"
    
    var fileCollection: FileCollection! {
        didSet {
            titleLabel.text = fileCollection.title
            subtitleLabel.text = fileCollection.subtitle.description
            overallProgress = fileCollection.importPhotos()
            fileCollection.overallProgress = overallProgress
        }
    }
    
    /// The overall progress for the import that is shown to the user
    fileprivate var overallProgress: Progress? {
        willSet {
            guard let formerProgress = overallProgress else { return }
            
            for overalProgressObservedKey in overalProgressObservedKeys {
                formerProgress.removeObserver(self, forKeyPath: overalProgressObservedKey, context: &fileCellObservationContext)
            }
        }
        
        didSet {
            if let newProgress = overallProgress {
                for overalProgressObservedKey in overalProgressObservedKeys {
                    newProgress.addObserver(self, forKeyPath: overalProgressObservedKey, options: [], context: &fileCellObservationContext)
                }
            }
            
            updateProgressView()
            updateToolbar()
        }
    }
    
    fileprivate var overallProgressIsFinished: Bool {
        let completed = overallProgress!.completedUnitCount
        let total = overallProgress!.totalUnitCount
        
        // An NSProgress is finished if it's not indeterminate, and the completedUnitCount > totalUnitCount.
        return (completed >= total && total > 0 && completed > 0) || (completed > 0 && total == 0)
    }
    
    fileprivate func updateProgressView() {
        if let overallProgress = self.overallProgress {
            progressView.progress = Float(overallProgress.fractionCompleted)
        }
    }
    
    fileprivate func updateToolbar() {
        
    }
    
    // MARK: Key-Value Observing
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &fileCellObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        OperationQueue.main.addOperation {
            self.updateProgressView()
            self.updateToolbar()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellId() -> String {
        return "fileCell"
    }

}
