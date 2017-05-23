//
//  EXIFImageProperties.swift
//  SwiftyImageIO
//
//  Created by Aliaksandr Bialiauski on 5/23/17.
//  Copyright © 2017 Alexander Belyavskiy. All rights reserved.
//

import Foundation
import ImageIO

public enum EXIFImageProperty {
  case exposureTime(TimeInterval)
}

extension EXIFImageProperty: ImageProperty {
  public static var key: String { return kCGImagePropertyExifDictionary as String }
  
  public init?(imageIOKey: String, value: AnyObject) {
    switch imageIOKey as CFString {
    case kCGImagePropertyExifExposureTime:
      guard let value = value as? NSNumber else {
        return nil
      }
      self = .exposureTime(value.doubleValue)
    default:
      return nil
    }
  }
  
  public var imageIOOption: (key: String, value: AnyObject) {
    switch self {
    case .exposureTime(let exposureTime):
      return (key: kCGImagePropertyExifExposureTime as String, value: exposureTime as NSNumber)    }
  }
}
