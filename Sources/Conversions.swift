import Foundation
import CoreGraphics

extension CFValueConvertible where Self: AnyObject {
  public var cfValue: AnyObject {
    self
  }
}

extension TimeInterval: CFValueRepresentable {
  public var cfValue: AnyObject {
    self as CFValue
  }

  public init(cfValue: NSNumber) {
    self = cfValue.doubleValue
  }
}

extension Bool: CFValueRepresentable {
  public var cfValue: AnyObject {
    self as CFValue
  }

  public init(cfValue: NSNumber) {
    self = cfValue.boolValue
  }
}

extension Int: CFValueRepresentable {
  public var cfValue: AnyObject {
    self as CFValue
  }

  public init(cfValue: NSNumber) {
    self = cfValue.intValue
  }
}

extension Data: CFValueRepresentable {
  public var cfValue: AnyObject {
    self as CFValue
  }

  public init(cfValue: NSData) {
    self = cfValue as Self
  }
}

extension String: CFValueRepresentable {
  public var cfValue: AnyObject {
    return self as CFValue
  }

  public init?(cfValue: NSString) {
    self = cfValue as Self
  }
}

extension CFDictionary: CFValueConvertible {}
extension CGColor: CFValueConvertible {}

extension Array: CFValueConvertible where Element == Int {
  public var cfValue: AnyObject {
    NSArray(array: self)
  }
}

extension Array: CFValueRepresentable where Element == Int {
  public init(cfValue: NSArray) {
    var convertedValues: [Element] = []
    for value in cfValue {
      guard let convertedValue = value as? Element else { assertionFailure("Invalid conversion"); break }
      convertedValues.append(convertedValue)
    }
    self = convertedValues
  }
}

extension Array where Element == (key: CFString, value: CFValueConvertible?) {
  func rawCfValues() -> CFValues {
    var values: CFValues = [:]
    for entry in self {
      values[entry.key] = entry.value
    }
    return values
  }
}
