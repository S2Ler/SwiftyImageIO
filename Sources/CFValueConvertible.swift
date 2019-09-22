import Foundation
import CoreGraphics

public protocol CFValueConvertible {
  var cfValue: AnyObject { get }
}
