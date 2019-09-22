import Foundation

@propertyWrapper
public struct CFProperty<T: CFValueRepresentable> {
  private let key: CFString
  public init(key: CFString) {
    self.key = key
  }
  public var wrappedValue: T?
  public var projectedValue: (key: CFString, value: CFValueConvertible?) {
    (key: key, value: wrappedValue)
  }

  public mutating func assign(from cfValues: RawCFValues) {
    guard let rawCfValue = cfValues[key] else { return }
    guard let cfValue = rawCfValue as? T.CFValue else {
      assertionFailure("Incorrect conversion type"); return
    }
    wrappedValue = T(cfValue: cfValue)
  }
}
