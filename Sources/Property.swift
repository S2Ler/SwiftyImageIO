//
//  Options.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 6/25/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

import Foundation
import ImageIO

public protocol Property {
  var imageIOOption: (key: String, value: AnyObject) { get }
}

public protocol ImageProperty: Property {
  static var key: String { get }
}

public final class ImageProperties {
  private let rawImageProperties: CFDictionary
  public let propertiesKey: String
  
  public init<PropertyType: ImageProperty>(_ imageProperties: [PropertyType]) {
    guard let anyProperty = imageProperties.first else {
      preconditionFailure(".imageProperties should contain at least one property")      
    }
    
    let imagePropertyKey = type(of: anyProperty).key
    self.propertiesKey = imagePropertyKey
    self.rawImageProperties = imageProperties.rawProperties()
  }
  
  public func rawProperties() -> CFDictionary {
    return rawImageProperties
  }
}

public extension Sequence where Iterator.Element: Property {
  public func rawProperties() -> CFDictionary {
    var dictionary: [String: AnyObject] = [:]
    for property in self {
      let (key, value) = property.imageIOOption
      dictionary[key] = value
    }
    
    return dictionary as CFDictionary
  }
}

public extension Sequence where Iterator.Element: ImageProperty {
  public func rawImageProperties() -> CFDictionary {
    let innerProperties = rawProperties()
    let outterProperties: [String: CFDictionary] = [Iterator.Element.key: innerProperties]
    return outterProperties as CFDictionary
  }
}
