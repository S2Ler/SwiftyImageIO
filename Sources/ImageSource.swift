import Foundation
import ImageIO

/** ImageSource objects, available in OS X v10.4 or later and iOS 4.0 and later, abstract the data-reading task. An image source can read image data from a URL, a CFData object, or a data consumer.

    After creating a ImageSource object for the appropriate source, you can obtain images, thumbnails, image properties, and other image information.
    - seealso: [CGImageSource](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGImageSource/index.html)
 */
public class ImageSource {
  /// Reference to CGImageSource object
  let imageSource: CGImageSource
  
  /**
   Creates an image source that reads from a location specified by a URL.
   
   - parameter url:     The URL to read from.
   - parameter options: An array of `ImageSource.Options` that specifies additional creation options. See `ImageSource.Options` for the keys you can supply.
   
   - returns: An `ImageSource` or nil, if `ImageSource` cannot be created for whatever reason.
   - seealso: `CGImageSourceCreateWithURL`
   */
  public init?(url: NSURL, options: [Options]?) {
    guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, options?.rawOptions()) else { return nil }
    self.imageSource = imageSource
  }
  
  /**
   Creates an image source that reads from a Foundation data object.
   
   - parameter data:    The data object to read from.
   - parameter options: An array of `ImageSource.Options` that specifies additional creation options. See `ImageSource.Options` for the keys you can supply.
   
   - returns: An `ImageSource` or nil, if `ImageSource` cannot be created for whatever reason.
   - seealso: `CGImageSourceCreateWithData`
   */
  public init?(data: NSData, options: [Options]?) {
    guard let imageSource = CGImageSourceCreateWithData(data as CFData, options?.rawOptions()) else { return nil }
    self.imageSource = imageSource
  }
  
  /**
   Creates an image source wrapper around `CGImageSource`
   
   - parameter imageSource: `CGImageSource` object to wrap around
   
   - returns: An `ImageSource` for `CGImageSource`
   */
  public init(imageSource: CGImageSource) {
    self.imageSource = imageSource
  }
  
  //TODO: CGImageSourceCreateWithDataProvider
  
  /**
   Available options which you can submit for various `ImageSource` functions
   
   - TypeIdentifierHint: The best guess of the uniform type identifier (UTI) for the format of the image source file. This key can be provided in the options dictionary when you create a `ImageSource` object.
   - ShouldAllowFloat: Whether the image should be returned as a CGImage object that uses floating-point values, if supported by the file format. CGImage objects that use extended-range floating-point values may require additional processing to render in a pleasing manner. The default value is `true`.
   - ShouldCache: Whether the image should be cached in a decoded form. The default value is `false` in 32-bit, `true` in 64-bit. This key can be provided in the options array that you can pass to the methods `propertiesForImage` and `properties`.
   - CreateThumbnailFromImageIfAbsent: Whether a thumbnail should be automatically created for an image if a thumbnail isn't present in the image source file. The thumbnail is created from the full image, subject to the limit specified by `kCGImageSourceThumbnailMaxPixelSize`. If a maximum pixel size isn't specified, then the thumbnail is the size of the full image, which in most cases is not desirable. The default value is `false`. This key can be provided in the options array that you pass to the method `createThumbnail`.
   - CreateThumbnailFromImageAlways: Whether a thumbnail should be created from the full image even if a thumbnail is present in the image source file. The thumbnail is created from the full image, subject to the limit specified by `kCGImageSourceThumbnailMaxPixelSize`. If a maximum pixel size isn't specified, then the thumbnail is the size of the full image, which probably isn't what you want. The default value is `false`. This key can be provided in the options array that you can pass to the method `createThumbnail`
   - ThumbnailMaxPixelSize: The maximum width and height in pixels of a thumbnail. If this key is not specified, the width and height of a thumbnail is not limited and thumbnails may be as big as the image itself. This key can be provided in the options array that you pass to the method `createThumbnail`
   - CreateThumbnailWithTransform: Whether the thumbnail should be rotated and scaled according to the orientation and pixel aspect ratio of the full image. The default value is `false`.
   */
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
  /// Converts ImageSource.Options to ImageIO key/value options
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

#if swift(>=3.0)
  public extension Sequence where Iterator.Element == ImageSource.Options {
    /// Converts array of ImageSource.Options to ImageIO dictionary of options
    func rawOptions() -> CFDictionary {
      var dictionary: [String: AnyObject] = [:]
      for option in self {
        let (key, value) = option.imageIOOption
        dictionary[key] = value
      }
      
      return dictionary as CFDictionary
    }
  }
#else
  public extension SequenceType where Generator.Element == ImageSource.Options {
    /// Converts array of ImageSource.Options to ImageIO dictionary of options
    func rawOptions() -> CFDictionary {
      var dictionary: [String: AnyObject] = [:]
      for option in self {
        let (key, value) = option.imageIOOption
        dictionary[key] = value
      }
      
      return dictionary as CFDictionary
    }
  }
#endif

/// Represents an incremental image source
public final class IncrementalImageSource: ImageSource {
}

public extension ImageSource {
  /// Returns an array of the UTIs that are supported for image sources.
  /// - seealso: `CGImageSourceCopyTypeIdentifiers`
  public static func supportedUTIs() -> [String] {
    let identifiers = CGImageSourceCopyTypeIdentifiers() as [AnyObject] as! [String]
    return identifiers
  }
  
  /// Returns whether ImageSource supports provided s`UTI`
  public static func supportsUTI(UTI: String) -> Bool {
    return supportedUTIs().contains(UTI)
  }
}

//MARK: - Creating Images From an Image Source
public extension ImageSource {
  /**
   Creates a CGImage object for the image data associated with the specified index in an image source.
   
   - parameter index:   The index that specifies the location of the image. The index is zero-based.
   - parameter options: An array that specifies additional creation options.
   
   - returns: Returns a `CGImage` object.
   - seealso: `CGImageSourceCreateImageAtIndex`

   */
  public func createImage(atIndex index: Int = 0, options: [Options]? = nil) -> CGImage? {
    return CGImageSourceCreateImageAtIndex(imageSource, index, options?.rawOptions())
  }
  
  /**
   Creates a thumbnail image of the image located at a specified location in an image source.
   
   - parameter index:   The index that specifies the location of the image. The index is zero-based.
   - parameter options: An array that specifies additional creation options.
   
   - returns: A `CGImage` object.
   - seealso: `CGImageSourceCreateThumbnailAtIndex`
   */
  public func createThumbnail(atIndex index: Int = 0, options: [Options]? = nil) -> CGImage? {
    return CGImageSourceCreateThumbnailAtIndex(imageSource, index, options?.rawOptions())
  }
  
  /**
   Create an incremental image source.
   
   - parameter options: An array that specifies additional creation options.
   
   - returns: Returns an image source object.
   - seealso: `CGImageSourceCreateIncremental`
   */
  public static func createIncremental(options options: [Options]? = nil) -> IncrementalImageSource {
    return IncrementalImageSource(imageSource: CGImageSourceCreateIncremental(options?.rawOptions()))
  }
}

// convenient
public extension ImageSource {
  /**
   Creates a thumbnail image of the image located at first index in an image source with the maximum width and height in pixels of a thumbnail equal to `size`.
   
   CreateThumbnailFromImageAlways = true
   
   - parameter size: The maximum width and height in pixels of a thumbnail.
   
   - returns: CGImage object
   */
  public func createThumbnail(size size: Int) -> CGImage? {
    return createThumbnail(atIndex: 0,
                           options: [.ThumbnailMaxPixelSize(size),
                            .CreateThumbnailFromImageAlways(true)])
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
  /// The uniform type identifier of the source container.
  /// - seealso: `CGImageSourceGetType`
  public var UTI: String? {
    return CGImageSourceGetType(imageSource) as String?
  }
  
  /// Returns the Core Foundation type ID for the image source.
  /// - seealso: `CGImageSourceGetTypeID`
  public static var typeID: CFTypeID {
    return CGImageSourceGetTypeID()
  }
  
  /// Returns the number of images (not including thumbnails) in the image source. If the image source is a multilayered PSD file, return 1.
  /// - seealso: `CGImageSourceGetCount`
  public var imageCount: Int {
    return CGImageSourceGetCount(imageSource)
  }
  
  /// Return the status of an image source.
  /// - seealso: `CGImageSourceGetStatus`
  public var status: CGImageSourceStatus {
    return CGImageSourceGetStatus(imageSource)
  }
  
  /// Returns the current status of an image that is at a specified location in an image source.
  /// - seealso: CGImageSourceGetStatusAtIndex
  public func statusForImage(atIndex index: Int = 0) -> CGImageSourceStatus {
    return CGImageSourceGetStatusAtIndex(imageSource, index)
  }
  
  /**
   Returns the properties of the image source.
   - returns: A dictionary that contains the properties associated with the image source container.
   - todo: Return wrapper around CFImageProperties
   - seealso: `CGImageSourceCopyProperties`
   - seealso: [CGImageProperties Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGImageProperties_Reference/) for a list of properties that can be in the dictionary.
   */
  public func properties(options: [Options]? = nil) -> [String: AnyObject]? {
    guard let rawProperties = CGImageSourceCopyProperties(imageSource, options?.rawOptions()) else { return nil }
    return (rawProperties as NSDictionary) as? [String: AnyObject]
  }
  
  
  /**
   Returns the properties of the image at a specified location in an image source.
   
   - parameter index:   The index of the image whose properties you want to obtain. The index is zero-based.
   - parameter options: An array you can use to request additional options.
   
   - returns: A dictionary that contains the properties associated with the image.
   
   - seealso: `CGImageSourceCopyPropertiesAtIndex`
   - seealso: [CGImageProperties Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGImageProperties_Reference/) for a list of properties that can be in the dictionary.
   - todo: Return wrapper around `CFImageProperties`
   */
  public func propertiesForImage(atIndex index: Int = 0, options: [Options]? = nil) -> [String: AnyObject]? {
    guard let rawProperties =  CGImageSourceCopyPropertiesAtIndex(imageSource, index, options?.rawOptions())
      else { return nil }
    return (rawProperties as NSDictionary) as? [String: AnyObject]
  }
}