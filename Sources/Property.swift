//
//  Options.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 6/25/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

import Foundation

public protocol Property {
  var imageIOOption: (key: String, value: AnyObject) { get }
}

public extension Sequence where Iterator.Element: Property {
  func rawProperties() -> CFDictionary {
    var dictionary: [String: AnyObject] = [:]
    for property in self {
      let (key, value) = property.imageIOOption
      dictionary[key] = value
    }
    
    return dictionary as CFDictionary
  }
}
