# SwiftyImageIO

[![Build Status](https://travis-ci.org/diejmon/SwiftyImageIO.svg?branch=master)](https://travis-ci.org/diejmon/SwiftyImageIO)
[![Version](https://img.shields.io/cocoapods/v/SwiftyImageIO.svg?style=flat)](http://cocoapods.org/pods/SwiftyImageIO)
[![License](https://img.shields.io/cocoapods/l/SwiftyImageIO.svg?style=flat)](http://cocoapods.org/pods/SwiftyImageIO)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyImageIO.svg?style=flat)](http://cocoapods.org/pods/SwiftyImageIO)

Swift wrapper around ImageIO framework.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Examples


### Create image thumbnail

```swift
import SwiftyImageIO

let source = ImageSource(data: imageData, options: nil)
let thumbnailCGImage = source?.createThumbnail(size: thumbnailSize)
```

### Write image to disk

```swift
import SwiftyImageIO
import MobileCoreServices

if let imageDestination = ImageDestination(url: saveURL, UTI: kUTTypeJPEG as String, imageCount: 1) {
  imageDestination.addImage(cgImage)
  let imageSaved = imageDestination.finalize()
}
```

## Requirements

## Installation

SwiftyImageIO is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyImageIO"
```

## Author

Alexander Belyavskiy, diejmon@gmail.com

## License

SwiftyImageIO is available under the MIT license. See the LICENSE file for more info.
