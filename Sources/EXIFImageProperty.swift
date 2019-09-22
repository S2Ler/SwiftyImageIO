import Foundation
import ImageIO

public struct EXIFImageProperties {
  public init() {}

  @CFProperty(key: kCGImagePropertyExifExposureTime)
  public var exposureTime: TimeInterval?
}

extension EXIFImageProperties: ImageProperties {
  public static var imageIOKey: CFString {
    return kCGImagePropertyExifDictionary
  }

  public var cfValues: CFValues {
    return [
      $exposureTime
    ].rawCfValues()
  }

  public init(_ cfValues: RawCFValues) {
    _exposureTime.assign(from: cfValues)
  }
}
