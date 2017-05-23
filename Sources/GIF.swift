#if canImport(UIKit)
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
    
    public struct FrameProperties {
      var delayTime: TimeInterval?
      var imageColorMap: Data? // TODO: Wrap color maps
      var unclampedDelayTime: TimeInterval?

      public init(delayTime: TimeInterval? = nil, imageColorMap: Data? = nil, unclampedDelayTime: TimeInterval? = nil) {
        self.delayTime = delayTime
        self.imageColorMap = imageColorMap
        self.unclampedDelayTime = unclampedDelayTime
      }
    }

    public struct Properties {
      var loopCount: Int?
      var hasGlobalColorMap: Bool?

      public init(loopCount: Int? = nil, hasGlobalColorMap: Bool? = nil) {
        self.loopCount = loopCount
        self.hasGlobalColorMap = hasGlobalColorMap
      }
    }

    public init() {
      
    }
    
    public func makeGIF(fromAnimatedImage animatedImage: UIImage,
                        writeTo path: String,
                        properties: Properties? = nil,
                        frameProperties: FrameProperties? = nil) throws {
      guard let images = animatedImage.images else {
        throw MakeError.notAnimatedImage
      }
      
      guard let imageDestination = ImageDestination(url: URL(fileURLWithPath: path),
                                                    UTI: UTI(kUTTypeGIF),
                                                    imageCount: images.count)
        else {
          throw MakeError.invalidPath
      }


      if let properties = properties {
        var imageDestinationProperties = ImageDestination.Properties()
        imageDestinationProperties.imageProperties = [properties]
        imageDestination.setProperties(imageDestinationProperties)
      }
      
      for image in images {
        guard let cgImage = image.cgImage else {
          throw MakeError.invalidImage
        }
        var frameImageDestinationProperties = ImageDestination.Properties()
        if let frameProperties = frameProperties {
          frameImageDestinationProperties.imageProperties = [frameProperties]
        }

        imageDestination.addImage(cgImage, properties: frameImageDestinationProperties)
      }
      
      let gifSaved = imageDestination.finalize()
      
      guard gifSaved else {
        throw MakeError.imageIOError
      }
    }    
  }

  extension GIF.Properties: ImageProperties {
    public static var imageIOKey: CFString {
      return kCGImagePropertyGIFDictionary
    }

    public var cfValues: CFValues {
      return [
        kCGImagePropertyGIFLoopCount: loopCount,
        kCGImagePropertyGIFHasGlobalColorMap: hasGlobalColorMap,
      ]
    }

    public init(_ cfValues: RawCFValues) {
      if let loopCount = cfValues[kCGImagePropertyGIFLoopCount] as? NSNumber {
        self.loopCount = loopCount.intValue
      }
      if let hasGlobalColorMap = cfValues[kCGImagePropertyGIFHasGlobalColorMap] as? NSNumber {
        self.hasGlobalColorMap = hasGlobalColorMap.boolValue
      }
    }

  }

extension GIF.FrameProperties: ImageProperties {
  public static var imageIOKey: CFString {
    return kCGImagePropertyGIFDictionary
  }

  public var cfValues: CFValues {
    return [
      kCGImagePropertyGIFDelayTime: delayTime,
      kCGImagePropertyGIFImageColorMap: imageColorMap,
      kCGImagePropertyGIFUnclampedDelayTime: unclampedDelayTime,
    ]
  }

  public init(_ cfValues: RawCFValues) {
    if let delayTime = cfValues[kCGImagePropertyGIFDelayTime] as? NSNumber {
      self.delayTime = delayTime.doubleValue
    }
  }

}

#endif
