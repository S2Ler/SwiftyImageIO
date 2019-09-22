import Foundation

public protocol CFValueRepresentable: CFValueConvertible {
  associatedtype CFValue: AnyObject
  init?(cfValue: CFValue)
}
