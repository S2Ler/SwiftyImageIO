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
  
  public init?(url: URL, UTI: UTITypeConvertible, imageCount: Int) {
    guard let imageDestination = CGImageDestinationCreateWithURL(url as CFURL, UTI.UTI.cfType, imageCount, nil)
      else { return nil }
    self.imageDestination = imageDestination
  }

  public init?(dataConsumer: CGDataConsumer, imageType: UTITypeConvertible, imageCount: Int, options: Properties? = nil) {
    guard let imageDestination = CGImageDestinationCreateWithDataConsumer(dataConsumer, imageType.UTI.cfType, imageCount, options?.rawCFValues())
      else { return nil }
    self.imageDestination = imageDestination
  }
  
  public struct Properties {
    public init() {}
    public var lossyCompressionQuality: Double?
    public var backgroundColor: CGColor?
    public var imageProperties: [ImageProperties]?
  }
}

// MARK: - Adding Images
public extension ImageDestination {
  func addImage(_ image: CGImage, properties: Properties? = nil) {
    CGImageDestinationAddImage(imageDestination, image, properties?.rawCFValues())
  }
  
  func addImage(from source: ImageSource, sourceImageIndex: Int, properties: Properties? = nil) {
    CGImageDestinationAddImageFromSource(imageDestination, source.imageSource, sourceImageIndex, properties?.rawCFValues())
  }
}

// MARK: - Getting Type Identifiers
public extension ImageDestination {
  static func supportedUTIs() -> [SwiftyImageIO.UTI] {
    return CGImageDestinationCopyTypeIdentifiers().convertToUTIs()
  }
  
  static func supportsUTI(_ UTI: UTITypeConvertible) -> Bool {
    return supportedUTIs().contains(UTI.UTI)
  }
  
  static var typeID: CFTypeID {
    return CGImageDestinationGetTypeID()
  }
}

// MARK: - Settings Properties
public extension ImageDestination {
  func setProperties(_ properties: Properties?) {
    CGImageDestinationSetProperties(imageDestination, properties?.rawCFValues())
  }
}

// MARK: - Finalizing an Image Destination
public extension ImageDestination {
  func finalize() -> Bool {
    return CGImageDestinationFinalize(imageDestination)
  }
}

extension ImageDestination.Properties: CFValuesRepresentable {
  public var cfValues: CFValues {
    var result: CFValues = [
      kCGImageDestinationLossyCompressionQuality: lossyCompressionQuality,
      kCGImageDestinationBackgroundColor: backgroundColor,
    ]
    imageProperties?.merge(into: &result)
    return result
  }
}

