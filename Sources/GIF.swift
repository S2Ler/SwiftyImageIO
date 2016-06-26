//
//  GIF.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 6/21/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

import Foundation
import UIKit
#if !os(OSX)
  import MobileCoreServices
import ImageIO

  public final class GIF {
    /// Errors for UIImage.makeGIF(atPath:)
    ///
    /// - InvalidPath:      path parameter is incorrect file path
    /// - NotAnimatedImage: target image isn't animated image
    /// - InvalidImage:     images do not have cgImage propery. CIImage backed UIImage not supported. Convert to CGImage first
    public enum MakeGIFError: ErrorProtocol {
      case InvalidPath
      case NotAnimatedImage
      case InvalidImage
      case ImageIOError
    }
    
    public enum Property {
      case LoopCount(Int)
      case DelayTime(TimeInterval)
      case ImageColorMap(Data)//TODO: Wrap color maps
      case HasGlobalColorMap(Bool)
      case UnclampedDelayTime(TimeInterval)
    }
    
    public init() {
      
    }
    
    public func makeGIF(fromAnimatedImage animatedImage: UIImage,
                        writeTo path: String,
                        gifProperties: [GIF.Property]? = nil) throws {
      guard let images = animatedImage.images else {
        throw MakeGIFError.NotAnimatedImage
      }
      
      guard let imageDestination = ImageDestination(url: URL(fileURLWithPath: path),
                                                    UTI: UTI(kUTTypeGIF),
                                                    imageCount: images.count)
        else {
          throw MakeGIFError.InvalidPath
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
          throw MakeGIFError.InvalidImage
        }
        imageDestination.addImage(cgImage, properties: gifFrameProperties)
      }
      
      let gifSaved = imageDestination.finalize()
      
      guard gifSaved else {
        throw MakeGIFError.ImageIOError
      }
    }
  }
  
  extension GIF.Property: ImageProperty {
    public var imageIOOption: (key: String, value: AnyObject) {
      switch self {
      case .LoopCount(let count):
        return (key: kCGImagePropertyGIFLoopCount as String, value: count)
      case .DelayTime(let delayTime):
        return (key: kCGImagePropertyGIFDelayTime as String, value: delayTime)
      case .ImageColorMap(let colorMap):
        return (key: kCGImagePropertyGIFImageColorMap as String, value: colorMap)
      case .HasGlobalColorMap(let flag):
        return (key: kCGImagePropertyGIFHasGlobalColorMap as String, value: flag)
      case .UnclampedDelayTime(let delay):
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
      case .LoopCount:
        fallthrough
      case .HasGlobalColorMap:
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
