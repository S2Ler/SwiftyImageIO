//
//  GIF.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 6/21/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

#if !os(OSX)
  import Foundation
  import UIKit
  import MobileCoreServices
  import ImageIO
  
  public final class GIF {
    /// Errors for UIImage.makeGIF(atPath:)
    ///
    /// - InvalidPath:      path parameter is incorrect file path
    /// - NotAnimatedImage: target image isn't animated image
    /// - InvalidImage:     images do not have cgImage propery. CIImage backed UIImage not supported. Convert to CGImage first
    public enum MakeError: Error {
      case invalidPath
      case notAnimatedImage
      case invalidImage
      case imageIOError
    }
    
    public enum Property {
      case loopCount(Int)
      case delayTime(TimeInterval)
      case imageColorMap(Data)//TODO: Wrap color maps
      case hasGlobalColorMap(Bool)
      case unclampedDelayTime(TimeInterval)
    }
    
    public init() {
      
    }
    
    public func makeGIF(fromAnimatedImage animatedImage: UIImage,
                        writeTo path: String,
                        properties: ImageProperties<GIF.Property>? = nil) throws {
      guard let images = animatedImage.images else {
        throw MakeError.notAnimatedImage
      }
      
      guard let imageDestination = ImageDestination(url: URL(fileURLWithPath: path),
                                                    UTI: UTI(kUTTypeGIF),
                                                    imageCount: images.count)
        else {
          throw MakeError.invalidPath
      }
      
      let frameProperties: [ImageDestination.Property]?
      
      if let properties = properties {
        imageDestination.setProperties([.imageProperties(properties.anyImageProperties)])
        frameProperties = [.imageProperties(properties.gifFrameProperties().anyImageProperties)]
      }
      else {
        frameProperties = nil
      }
      
      for image in images {
        guard let cgImage = image.cgImage else {
          throw MakeError.invalidImage
        }
        imageDestination.addImage(cgImage, properties: frameProperties)
      }
      
      let gifSaved = imageDestination.finalize()
      
      guard gifSaved else {
        throw MakeError.imageIOError
      }
    }    
  }
  
  extension GIF.Property: ImageProperty {
    public init?(imageIOKey: String, value: AnyObject) {
      switch imageIOKey as CFString {
      case kCGImagePropertyGIFLoopCount:
        guard let value = value as? NSNumber else {
          return nil
        }
        self = .loopCount(value.intValue)
      case kCGImagePropertyGIFDelayTime:
        guard let value = value as? NSNumber else {
          return nil
        }
        self = .delayTime(value.doubleValue)
      case kCGImagePropertyGIFImageColorMap:
        guard let value = value as? NSData else {
          return nil
        }
        self = .imageColorMap(value as Data)
      case kCGImagePropertyGIFHasGlobalColorMap:
        guard let value = value as? NSNumber else {
          return nil
        }
        self = .hasGlobalColorMap(value.boolValue)
      case kCGImagePropertyGIFUnclampedDelayTime:
        guard let value = value as? NSNumber else {
          return nil
        }
        self = .unclampedDelayTime(value.doubleValue)
      default:
        return nil
      }
    }
    public var imageIOOption: (key: String, value: AnyObject) {
      switch self {
      case .loopCount(let count):
        return (key: kCGImagePropertyGIFLoopCount as String, value: count as NSNumber)
      case .delayTime(let delayTime):
        return (key: kCGImagePropertyGIFDelayTime as String, value: delayTime as NSNumber)
      case .imageColorMap(let colorMap):
        return (key: kCGImagePropertyGIFImageColorMap as String, value: colorMap as NSData)
      case .hasGlobalColorMap(let flag):
        return (key: kCGImagePropertyGIFHasGlobalColorMap as String, value: flag as NSNumber)
      case .unclampedDelayTime(let delay):
        return (key: kCGImagePropertyGIFUnclampedDelayTime as String, value: delay as NSNumber)
      }
    }
    
    static public var key: String {
      return kCGImagePropertyGIFDictionary as String
    }
  }
  
  public extension GIF.Property {
    var isFileScopeProperty: Bool {
      switch self {
      case .loopCount:
        fallthrough
      case .hasGlobalColorMap:
        return true
      default:
        return false
      }
    }
  }
  
  private extension ImageProperties where PropertyType == GIF.Property {
    func gifFileProperties() -> ImageProperties<PropertyType> {
      return ImageProperties(self.filter({ $0.isFileScopeProperty }))
    }
    
    func gifFrameProperties() -> ImageProperties<PropertyType> {
      return ImageProperties(self.filter({ !$0.isFileScopeProperty }))
    }
  }
  
#endif
