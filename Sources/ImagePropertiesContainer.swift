//
//  ImagePropertiesContainer.swift
//  SwiftyImageIO_iOS
//
//  Created by Aliaksandr Bialiauski on 12/8/17.
//  Copyright © 2017 Alexander Belyavskiy. All rights reserved.
//

import Foundation

public struct ImagePropertiesContainer {
  private var rawCFValues: RawCFValues = [:]

  public init(_ rawCFValues: RawCFValues) {
    self.rawCFValues = rawCFValues
  }

  public func get<ImagePropertiesType: ImageProperties>(_ kind: ImagePropertiesType.Type) -> ImagePropertiesType? {
    guard let rawCFImageProperties = rawCFValues[ImagePropertiesType.imageIOKey] else {
      return nil
    }

    guard let cfValue = rawCFImageProperties as? RawCFValues else {
      preconditionFailure("ImageIO implementation changed. Investigate.")
    }

    return ImagePropertiesType(cfValue)
  }

  public mutating func add<ImagePropertiesType: ImageProperties>(_ imageProperties: ImagePropertiesType) {
    rawCFValues[ImagePropertiesType.imageIOKey] = imageProperties.rawCFValues()
  }

  public mutating func mutate<ImagePropertiesType: ImageProperties>(with block: (inout ImagePropertiesType?) -> Void) {
    var imageProperties: ImagePropertiesType? = self.get(ImagePropertiesType.self)
    block(&imageProperties)

    if let imageProperties = imageProperties {
      add(imageProperties)
    }
  }
}

