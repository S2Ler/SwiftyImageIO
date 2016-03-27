import ImageIO

//TODO: Copy/Paste documentation from ImageIO

public class ImageSource {
  let imageSource: CGImageSource
  
  public init?(url: NSURL, options: [Options]?) {
    guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, options?.rawOptions()) else { return nil }
    self.imageSource = imageSource
  }
  
  public init?(data: NSData, options: [Options]?) {
    guard let imageSource = CGImageSourceCreateWithData(data as CFData, options?.rawOptions()) else { return nil }
    self.imageSource = imageSource
  }
  
  public init(imageSource: CGImageSource) {
    self.imageSource = imageSource
  }
  
  //TODO: CGImageSourceCreateWithDataProvider
  
  public enum Options {
    case TypeIdentifierHint(UTI: String)
    case ShouldAllowFloat(Bool)
    case ShouldCache(Bool)
    case CreateThumbnailFromImageIfAbsent(Bool)
    case CreateThumbnailFromImageAlways(Bool)
    case ThumbnailMaxPixelSize(Int)
    case CreateThumbnailWithTransform(Bool)
  }
}

public extension ImageSource.Options {
  public var imageIOOption: (key: String, value: AnyObject) {
    switch self {
    case .TypeIdentifierHint(let UTI):
      return (key: kCGImageSourceTypeIdentifierHint as String, value: UTI)
    case .ShouldAllowFloat(let allow):
      return (key: kCGImageSourceShouldAllowFloat as String, value: allow)
    case .ShouldCache(let shouldCache):
      return (key: kCGImageSourceShouldCache as String, value: shouldCache)
    case .CreateThumbnailFromImageIfAbsent(let createThumbnail):
      return (key: kCGImageSourceCreateThumbnailFromImageIfAbsent as String, value: createThumbnail)
    case .CreateThumbnailFromImageAlways(let createThumbnail):
      return (key: kCGImageSourceCreateThumbnailFromImageAlways as String, value: createThumbnail)
    case .ThumbnailMaxPixelSize(let size):
      return (key: kCGImageSourceThumbnailMaxPixelSize as String, value: size)
    case .CreateThumbnailWithTransform(let createWithTransform):
      return (key: kCGImageSourceCreateThumbnailWithTransform as String, value: createWithTransform)
    }
  }
}

public extension SequenceType where Generator.Element == ImageSource.Options {
  func rawOptions() -> CFDictionary {
    var dictionary: [String: AnyObject] = [:]
    for option in self {
      let (key, value) = option.imageIOOption
      dictionary[key] = value
    }
    
    return dictionary as CFDictionary
  }
}

public final class IncrementalImageSource: ImageSource {
}

public extension ImageSource {
  public static func supportedUTIs() -> [String] {
    let identifiers = CGImageSourceCopyTypeIdentifiers() as [AnyObject] as! [String]
    return identifiers
  }
  
  public static func supportsUTI(UTI: String) -> Bool {
    return supportedUTIs().contains(UTI)
  }
}

//MARK: - Creating Images From an Image Source
public extension ImageSource {
  public func createImage(atIndex index: Int = 0, options: [Options]? = nil) -> CGImage? {
    return CGImageSourceCreateImageAtIndex(imageSource, index, options?.rawOptions())
  }
  
  public func createThumbnail(atIndex index: Int = 0, options: [Options]? = nil) -> CGImage? {
    return CGImageSourceCreateThumbnailAtIndex(imageSource, index, options?.rawOptions())
  }
  
  public static func createIncremental(options options: [Options]? = nil) -> IncrementalImageSource {
    return IncrementalImageSource(imageSource: CGImageSourceCreateIncremental(options?.rawOptions()))
  }
}

//MARK: - Updating an Image Source
public extension IncrementalImageSource {
  public func update(data data: NSData, isFinal: Bool) {
    CGImageSourceUpdateData(imageSource, data as CFData, isFinal)
  }
  
  //TODO: Implement CGImageSourceUpdateDataProvider
}


//MARK: - Getting Information From an Image Source
public extension ImageSource {
  public var UTI: String? {
    return CGImageSourceGetType(imageSource) as String?
  }
  
  public static var typeID: CFTypeID {
    return CGImageSourceGetTypeID()
  }
  
  public var imageCount: Int {
    return CGImageSourceGetCount(imageSource)
  }
  
  public var status: CGImageSourceStatus {
    return CGImageSourceGetStatus(imageSource)
  }
  
  public func statusForImage(atIndex index: Int = 0) -> CGImageSourceStatus {
    return CGImageSourceGetStatusAtIndex(imageSource, index)
  }
  
  //TODO: Return wrapper around CFImageProperties
  public func properties(options: [Options]? = nil) -> [String: AnyObject]? {
    guard let rawProperties = CGImageSourceCopyProperties(imageSource, options?.rawOptions()) else { return nil }
    return (rawProperties as NSDictionary) as? [String: AnyObject]
  }
  
  //TODO: Return wrapper around CFImageProperties
  public func propertiesForImage(atIndex index: Int = 0, options: [Options]? = nil) -> [String: AnyObject]? {
    guard let rawProperties =  CGImageSourceCopyPropertiesAtIndex(imageSource, index, options?.rawOptions())
      else { return nil }
    return (rawProperties as NSDictionary) as? [String: AnyObject]
  }
}