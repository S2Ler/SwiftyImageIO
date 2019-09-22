import Foundation
import ImageIO

public struct GPSImageProperties {
  public init() {}

  @CFProperty(key: kCGImagePropertyGPSVersion)
  public var version: [Int]?

  @CFProperty(key: kCGImagePropertyGPSStatus)
  public var status: Status?

  @CFProperty(key: kCGImagePropertyGPSLatitudeRef)
  public var latitudeRef: LatitudeRef?

  @CFProperty(key: kCGImagePropertyGPSLatitude)
  public var latitude: Double?

  @CFProperty(key: kCGImagePropertyGPSLongitudeRef)
  public var longitudeRef: LongitudeRef?

  @CFProperty(key: kCGImagePropertyGPSLongitude)
  public var longitude: Double?

  @CFProperty(key: kCGImagePropertyGPSAltitudeRef)
  public var altitudeRef: AltitudeRef?

  @CFProperty(key: kCGImagePropertyGPSAltitude)
  public var altitude: Double?

  @CFProperty(key: kCGImagePropertyGPSSatellites)
  public var satellites: String?

  @CFProperty(key: kCGImagePropertyGPSDateStamp)
  public var datestamp: String?

  @CFProperty(key: kCGImagePropertyGPSTimeStamp)
  public var timestamp: String?

  @CFProperty(key: kCGImagePropertyGPSMapDatum)
  public var mapDatum: String?

  @CFProperty(key: kCGImagePropertyGPSMeasureMode)
  public var measureMode: MeasureMode?

  @CFProperty(key: kCGImagePropertyGPSDOP)
  public var dataDegreeOfPrecision: Double?

  @CFProperty(key: kCGImagePropertyGPSSpeedRef)
  public var speedRef: SpeedRef?

  @CFProperty(key: kCGImagePropertyGPSSpeed)
  public var speed: Double?

  @CFProperty(key: kCGImagePropertyGPSTrackRef)
  public var trackRef: Direction?

  @CFProperty(key: kCGImagePropertyGPSTrack)
  public var track: Double?

  @CFProperty(key: kCGImagePropertyGPSImgDirectionRef)
  public var imageDirectionRef: Direction?

  @CFProperty(key: kCGImagePropertyGPSImgDirection)
  public var imageDirection: Double?

  @CFProperty(key: kCGImagePropertyGPSDestLatitudeRef)
  public var destinationLatitudeRef: LatitudeRef?

  @CFProperty(key: kCGImagePropertyGPSDestLatitude)
  public var destinationLatitude: Double?

  @CFProperty(key: kCGImagePropertyGPSDestLongitudeRef)
  public var destinationLongitudeRef: LongitudeRef?

  @CFProperty(key: kCGImagePropertyGPSDestLongitude)
  public var destinationLongitude: Double?

  @CFProperty(key: kCGImagePropertyGPSDestBearingRef)
  public var destinationBearingRef: Direction?

  @CFProperty(key: kCGImagePropertyGPSDestBearing)
  public var destinationBearing: Double?

  @CFProperty(key: kCGImagePropertyGPSDestDistanceRef)
  public var destinationDistanceRef: DistanceRef?

  @CFProperty(key: kCGImagePropertyGPSDestDistance)
  public var destinationDistance: Double?

  @CFProperty(key: kCGImagePropertyGPSDateStamp)
  public var dateStamp: String?

  @CFProperty(key: kCGImagePropertyGPSDifferental)
  public var differential: Differential?

  /*
   Missing entries: kCGImagePropertyGPSProcessingMethod, kCGImagePropertyGPSAreaInformation
   */
}

extension GPSImageProperties: ImageProperties {
  public static var imageIOKey: CFString {
    return kCGImagePropertyGPSDictionary
  }

  public var cfValues: CFValues {
    [
      $version,
      $status,
      $latitudeRef,
      $latitude,
      $longitudeRef,
      $longitude,
      $altitudeRef,
      $altitude,
      $satellites,
      $datestamp,
      $timestamp,
      $mapDatum,
      $measureMode,
      $dataDegreeOfPrecision,
      $speedRef,
      $speed,
      $trackRef,
      $track,
      $imageDirectionRef,
      $imageDirection,
      $destinationLatitudeRef,
      $destinationLatitude,
      $destinationLongitudeRef,
      $destinationLongitude,
      $destinationBearingRef,
      $destinationBearing,
      $destinationDistanceRef,
      $destinationDistance,
      $datestamp,
      $differential,
    ].rawCfValues()
  }

  public init(_ cfValues: RawCFValues) {
    _version.assign(from: cfValues)
    _status.assign(from: cfValues)
    _latitudeRef.assign(from: cfValues)
    _latitude.assign(from: cfValues)
    _longitudeRef.assign(from: cfValues)
    _longitude.assign(from: cfValues)
    _altitudeRef.assign(from: cfValues)
    _altitude.assign(from: cfValues)
    _satellites.assign(from: cfValues)
    _datestamp.assign(from: cfValues)
    _timestamp.assign(from: cfValues)
    _mapDatum.assign(from: cfValues)
    _measureMode.assign(from: cfValues)
    _dataDegreeOfPrecision.assign(from: cfValues)
    _speedRef.assign(from: cfValues)
    _speed.assign(from: cfValues)
    _trackRef.assign(from: cfValues)
    _track.assign(from: cfValues)
    _imageDirectionRef.assign(from: cfValues)
    _imageDirection.assign(from: cfValues)
    _destinationLatitudeRef.assign(from: cfValues)
    _destinationLatitude.assign(from: cfValues)
    _destinationLongitudeRef.assign(from: cfValues)
    _destinationLongitude.assign(from: cfValues)
    _destinationBearingRef.assign(from: cfValues)
    _destinationBearing.assign(from: cfValues)
    _destinationDistanceRef.assign(from: cfValues)
    _destinationDistance.assign(from: cfValues)
    _datestamp.assign(from: cfValues)
    _differential.assign(from: cfValues)
  }
}

public extension GPSImageProperties {
  enum LatitudeRef: String {
    case north = "N"
    case south = "S"
  }
  
  enum LongitudeRef: String {
    case east = "E"
    case west = "W"
  }
  
  enum AltitudeRef: Int {
    case aboveSeaLevel
    case belowSeaLevel
  }
  
  enum Status: String {
    case measurementInProgress = "A"
    case measurementInteroperability = "V"
  }
  
  enum MeasureMode: String {
    case twoDimensional = "2"
    case threeDimensional = "3"
  }
  
  enum SpeedRef: String {
    case kmPerHour = "K"
    case milesPerHour = "M"
    case knots = "N"
  }

  enum Direction: String {
    case `true` = "T"
    case magnetic = "M"
  }

  enum DistanceRef: String {
    case km = "K"
    case miles = "M"
    case knots = "N"
  }

  enum Differential: Int {
    case withoutCorrection = 0
    case correctionApplied = 1
  }
}

extension GPSImageProperties.LatitudeRef: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.LongitudeRef: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.AltitudeRef: CFValueRepresentable {
  public typealias CFValue = NSNumber
}
extension GPSImageProperties.Status: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.MeasureMode: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.SpeedRef: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.Direction: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.DistanceRef: CFValueRepresentable {
  public typealias CFValue = NSString
}
extension GPSImageProperties.Differential: CFValueRepresentable {
  public typealias CFValue = NSNumber
}

extension RawRepresentable where RawValue == String {
  public var cfValue: AnyObject {
    rawValue as NSString
  }

  public init?(cfValue: NSString) {
    if let rawValue = Self.init(rawValue: cfValue as String) {
      self = rawValue
    }
    else {
      return nil
    }
  }
}

extension RawRepresentable where RawValue == Int {
  public var cfValue: AnyObject {
    rawValue as NSNumber
  }

  public init?(cfValue: NSNumber) {
    if let rawValue = Self.init(rawValue: cfValue.intValue) {
      self = rawValue
    }
    else {
      return nil
    }
  }
}
