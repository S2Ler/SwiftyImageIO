//
//  UTI.swift
//  SwiftyImageIO
//
//  Created by Alexander Belyavskiy on 5/21/16.
//  Copyright © 2016 Alexander Belyavskiy. All rights reserved.
//

import Foundation

//MARK: - UTI
public struct UTI {
  public let cfType: CFString
  
  public init(_ cfType: CFString) {
    self.cfType = cfType
  }
  
  public init(_ type: String) {
    self.cfType = type as CFString
  }
}

extension UTI: StringLiteralConvertible {
  public init(unicodeScalarLiteral value: StringLiteralType) {
    cfType = value as CFString
  }
  
  public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    cfType = value as CFString
  }
  
  public init(stringLiteral value: StringLiteralType) {
    cfType = value as CFString
  }
}

//MARK: - UTITypeConvertible
public protocol UTITypeConvertible {
  var UTI: SwiftyImageIO.UTI { get }
}

extension CFString: UTITypeConvertible {
  public var UTI: SwiftyImageIO.UTI {
    return SwiftyImageIO.UTI(self)
  }
}

extension String: UTITypeConvertible {
  public var UTI: SwiftyImageIO.UTI {
    return SwiftyImageIO.UTI(self)
  }
}

extension UTI: UTITypeConvertible {
  public var UTI: SwiftyImageIO.UTI {
    return self
  }
}

//MARK: - Hashable
extension UTI: Hashable {
  public var hashValue: Int {
    return Int(CFHash(cfType))
  }
}

//MARK: - Equatable
extension UTI: Equatable {
  
}

public func ==(lhs: UTI, rhs: UTI) -> Bool {
  return CFStringCompare(lhs.cfType, rhs.cfType, CFStringCompareFlags()) == .CompareEqualTo
}

public func ==(lhs: UTI, rhs: UTITypeConvertible) -> Bool {
  return CFStringCompare(lhs.cfType, rhs.UTI.cfType, CFStringCompareFlags()) == .CompareEqualTo
}

public func ==(lhs: UTITypeConvertible, rhs: UTI) -> Bool {
  return CFStringCompare(lhs.UTI.cfType, rhs.cfType, CFStringCompareFlags()) == .CompareEqualTo
}
