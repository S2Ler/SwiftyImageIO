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
    public enum MakeGIFError: Error {
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
                        gifProperties: [GIF.Property]? = nil) throws {
      guard let images = animatedImage.images else {
        throw MakeGIFError.notAnimatedImage
      }
      
      guard let imageDestination = ImageDestination(url: URL(fileURLWithPath: path),
                                                    UTI: UTI(kUTTypeGIF),
                                                    imageCount: images.count)
        else {
          throw MakeGIFError.invalidPath
      }
      
      let gifFrameProperties: [ImageDestination.Property]?
      
      if let gifProperties = gifProperties {
        imageDestination.setProperties([.imageProperties(ImageProperties(gifProperties))])
        gifFrameProperties = [.imageProperties(ImageProperties(gifProperties.gifFrameProperties()))]
      }
      else {
        gifFrameProperties = nil
      }
      
      for image in images {
        guard let cgImage = image.cgImage else {
          throw MakeGIFError.invalidImage
        }
        imageDestination.addImage(cgImage, properties: gifFrameProperties)
      }
      
      let gifSaved = imageDestination.finalize()
      
      guard gifSaved else {
        throw MakeGIFError.imageIOError
      }
    }    
  }
  
  extension GIF.Property: ImageProperty {
    public var imageIOOption: (key: String, value: AnyObject) {
      switch self {
      case .loopCount(let count):
        return (key: kCGImagePropertyGIFLoopCount as String, value: count)
      case .delayTime(let delayTime):
        return (key: kCGImagePropertyGIFDelayTime as String, value: delayTime)
      case .imageColorMap(let colorMap):
        return (key: kCGImagePropertyGIFImageColorMap as String, value: colorMap)
      case .hasGlobalColorMap(let flag):
        return (key: kCGImagePropertyGIFHasGlobalColorMap as String, value: flag)
      case .unclampedDelayTime(let delay):
        return (key: kCGImagePropertyGIFUnclampedDelayTime as String, value: delay)
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
  
  private extension Sequence where Iterator.Element == GIF.Property {
    func gifFileProperties() -> [Iterator.Element] {
      return self.filter { $0.isFileScopeProperty }
    }
    
    func gifFrameProperties() -> [Iterator.Element] {
      return self.filter { !$0.isFileScopeProperty }
    }
  }
  
  
#endif
