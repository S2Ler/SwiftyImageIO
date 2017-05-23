import Foundation

public protocol ImageProperties: CFValuesRepresentable, CFValuesConvertible, CFImagePropertiesRepresentable {
  static var imageIOKey: CFString { get }
}

public extension ImageProperties {
  var cfImageProperties: CFImageProperties {
    return CFImageProperties(self)
  }
}
