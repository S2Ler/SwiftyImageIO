import Foundation

public protocol CFValuesRepresentable {
  var cfValues: CFValues { get }
}

internal extension CFValuesRepresentable {
  func rawCFValues() -> CFDictionary {
    var result: [CFString: AnyObject] = [:]

    for (imageIOKey, value) in cfValues {
      result[imageIOKey] = value?.cfValue
    }

    return result as CFDictionary
  }
}
