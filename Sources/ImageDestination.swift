import Foundation
import ImageIO

//TODO: Copy/Paste documentation from ImageIO

public final class ImageDestination {
  let imageDestination: CGImageDestination
  
  public init?(data: NSMutableData, UTI: UTITypeConvertible, imageCount: Int) {
    guard let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, UTI.UTI.cfType, imageCount, nil)
      else { return nil }
    self.imageDestination = imageDestination
  }
  
  public init?(url: NSURL, UTI: UTITypeConvertible, imageCount: Int) {
    guard let imageDestination = CGImageDestinationCreateWithURL(url as CFURL, UTI.UTI.cfType, imageCount, nil)
      else { return nil }
    self.imageDestination = imageDestination
  }

  public init?(dataConsumer: CGDataConsumer, imageType: CFString, imageCount: Int, options: [Property]? = nil) {
    guard let imageDestination = CGImageDestinationCreateWithDataConsumer(dataConsumer, imageType, imageCount, options?.rawProperties())
      else { return nil }
    self.imageDestination = imageDestination
  }
  
  public enum Property {
    case LossyCompressionQuality(Double)
    case MaximumCompressionQuality
    case LosslessCompressionQuality
    case BackgroundColor(CGColor)
    case ImageProperty(key: String, value: AnyObject)
  }
}

public extension ImageDestination.Property {
  public var imageIOProperty: (key: String, value: AnyObject) {
    switch self {
    case .LossyCompressionQuality(let quality):
      return (key: kCGImageDestinationLossyCompressionQuality as String, value: quality)
    case .MaximumCompressionQuality:
      return (key: kCGImageDestinationLossyCompressionQuality as String, value: 0.0)
    case .LosslessCompressionQuality:
      return (key: kCGImageDestinationLossyCompressionQuality as String, value: 1.0)
    case .BackgroundColor(let color):
      return (key: kCGImageDestinationBackgroundColor as String, value: color)
    case .ImageProperty(let key, let value):
      return (key: key, value: value)
    }
  }
}


public extension SequenceType where Generator.Element == ImageDestination.Property {
  func rawProperties() -> CFDictionary {
    var dictionary: [String: AnyObject] = [:]
    for property in self {
      let (key, value) = property.imageIOProperty
      dictionary[key] = value
    }
    
    return dictionary as CFDictionary
  }
}

//MARK: - Adding Images
public extension ImageDestination {
  public func addImage(image: CGImage, properties: [Property]? = nil) {
    CGImageDestinationAddImage(imageDestination, image, properties?.rawProperties())
  }
  
  public func addImage(fromSource source: ImageSource, sourceImageIndex: Int, properties: [Property]? = nil) {
    CGImageDestinationAddImageFromSource(imageDestination, source.imageSource, sourceImageIndex, properties?.rawProperties())
  }
}

//MARK: - Getting Type Identifiers
public extension ImageDestination {
  public static func supportedUTIs() -> [SwiftyImageIO.UTI] {
    return CGImageDestinationCopyTypeIdentifiers().convertToUTIs()
  }
  
  public static func supportsUTI(UTI: UTITypeConvertible) -> Bool {
    return supportedUTIs().contains(UTI.UTI)
  }
  
  public static var typeID: CFTypeID {
    return CGImageDestinationGetTypeID()
  }
}

//MARK: - Settings Properties
public extension ImageDestination {
  public func setProperties(properties: [Property]?) {
    CGImageDestinationSetProperties(imageDestination, properties?.rawProperties())
  }
}

//MARK: - Finalizing an Image Destination
public extension ImageDestination {
  public func finalize() -> Bool {
    return CGImageDestinationFinalize(imageDestination)
  }
}

