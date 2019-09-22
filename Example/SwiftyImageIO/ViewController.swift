//
//  ViewController.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 03/27/2016.
//  Copyright (c) 2016 Alexander Belyavskiy. All rights reserved.
//

import UIKit
import SwiftyImageIO
import MobileCoreServices

public extension UIView {
    @available(iOS 10.0, *)
    func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

        let snapshotImage = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return snapshotImage
    }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let imageData = view.renderToImage().jpegData(compressionQuality: 0.8)!
    let source = ImageSource(data: imageData, options: nil)!
    let thumbnailCGImage = source.createThumbnail(maxPixelSize: 100)!

    let saveURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("image.jpg")
    if let imageDestination = ImageDestination(url: saveURL, UTI: kUTTypeJPEG, imageCount: 1) {
      imageDestination.addImage(thumbnailCGImage)
      let imageSaved = imageDestination.finalize()
      print("Image saved: \(imageSaved) at \(saveURL)")
    }

    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

