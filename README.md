# ImageDownloader

## Requirements

### Build

Xcode 8.0, Swift 3.0, iOS 10.0 SDK.

### Runtime

iOS 9.0+, recommend iOS 10.0 or Highest.

## Main Issue
  1. When go to `PhotoCollectionViewController.Swift` by tap in `FileCell` on Screen 1,
  It's block `Main UI`, so You need to wait some to go to new screen.
  Currently, I can't know how to fix it.

  You can force it by hard code by download some data.

  Example: In `FileCollection.swift`, at method `importPhotos`
  ```swift
  func importPhotos() -> Progress {
        let progress = Progress()
        // Hard code for download some data per json file
        let total = photos.count > 10 ? 10 : photos.count
        progress.totalUnitCount = Int64(total)
        for index in 0..<total {
            let photo = photos[index]
            let importProgress = photo.startImport()
            progress.addChild(importProgress, withPendingUnitCount: 1)
        }
        return progress
    }
  ```

  2. Handle some status in `Screen 1` is not correctly.

## Feature Not Implement
    Background tranfer

## Explain
    I do a things at once both: in the company and do this short assignment,
    so 3 days is short for me.
    Moreover, I don't have many experience when custom and handle thread.
