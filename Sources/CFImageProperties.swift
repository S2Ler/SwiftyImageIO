import Foundation

public class CFImageProperties  {
  public let cfValues: CFDictionary
  public let imageIOKey: CFString

  public init<T: ImageProperties>(_ value: T) {
    imageIOKey = T.imageIOKey
    cfValues = value.rawCFValues()
  }
}

internal extension Array where Element == ImageProperties {
  func merge(into cfValues: inout CFValues) {
    for imageProperties in self {
      let cfImageProperties = imageProperties.cfImageProperties
      cfValues[cfImageProperties.imageIOKey] = cfImageProperties.cfValues
    }
  }
}

public protocol CFImagePropertiesRepresentable {
  var cfImageProperties: CFImageProperties { get }
}
