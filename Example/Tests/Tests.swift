#if canImport(AppKit)
  import AppKit
#elseif canImport(UIKit)
  import UIKit
#endif
import XCTest
import SwiftyImageIO
#if canImport(MobileCoreServices)
  import MobileCoreServices
#endif
import Foundation

internal let bundle = Bundle(for: Tests.self)

class Tests: XCTestCase {
  
  func testSourceSupportedIdentifiers() {
    let identifiers = ImageSource.supportedUTIs()
    
    XCTAssert(identifiers.contains(UTI(kUTTypePNG)), "")
    
    for identifier in identifiers {
      XCTAssertTrue(ImageSource.supportsUTI(identifier))
    }
  }
  
  func testDestinationSupportedIdentifiers() {
    let identifiers = ImageDestination.supportedUTIs()
    
    XCTAssert(identifiers.contains(UTI(kUTTypePNG)), "")
    
    for identifier in identifiers {
      XCTAssertTrue(ImageDestination.supportsUTI(identifier))
    }
  }

  func testGifImageSource() {
    let imageSource = ImageSource(url: gifImageURL, options: nil)!
    XCTAssert(imageSource.imageCount == 120)
    XCTAssert(imageSource.status == .statusComplete)
    for imageIndex in (0..<imageSource.imageCount) {
      XCTAssertNotNil(imageSource.createImage(atIndex: imageIndex, options: nil))
    }
    XCTAssert(imageSource.UTI! == "com.compuserve.gif")
  }
  
  func testPngImageSource() {
    var options = ImageSource.Options()
    options.typeIdentifierHint = kUTTypePNG
    let imageSource = ImageSource(url: pngImageURL, options: options)!
    XCTAssert(imageSource.imageCount == 1)
    XCTAssert(imageSource.status == .statusComplete)
    XCTAssertNotNil(imageSource.createImage())
    XCTAssert(imageSource.UTI! == kUTTypePNG)
  }
  
  func testImageDestination() {
    let data = NSMutableData()

    guard let destination = ImageDestination(data: data, UTI: kUTTypePNG, imageCount: 1) else {
      XCTFail();
      return
    }
    
    let cgimage: CGImage = cgImage(at: pngImageURL)

    destination.addImage(cgimage)
    XCTAssertTrue(destination.finalize())
    #if os(OSX)
      let out_image = NSImage(data: data as Data)
    #else
      let out_image = UIImage(data: data as Data)
    #endif
    
    XCTAssertNotNil(out_image)
  }
  
  func testEquatable() {
    let UTIPure = UTI("a")
    let UTIPure2 = UTI("a")
    let UTIConvertible = "a"
    let UTIConvertible2 = "a"
    XCTAssert(UTIPure == UTIConvertible)
    XCTAssert(UTIConvertible == UTIPure)
    XCTAssert(UTIConvertible == UTIConvertible2)
    XCTAssert(UTIPure == UTIPure2)
  }
  
  func testEXIF() {
    let data = NSMutableData()
    
    guard let destination = ImageDestination(data: data, UTI: kUTTypeJPEG, imageCount: 1) else {
      XCTFail();
      return
    }
    
    let cgimage: CGImage = cgImage(at: pngImageURL)
    let exposureTime = TimeInterval(10)
    var exifProperties = EXIFImageProperties()
    exifProperties.exposureTime = exposureTime

    var properties = ImageDestination.Properties()
    properties.imageProperties = [exifProperties]
    destination.addImage(cgimage, properties: properties)
    XCTAssertTrue(destination.finalize())
    
    var url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    url.appendPathComponent("tmp.jpeg")
    try! data.write(to: url, options: NSData.WritingOptions.atomic)
    
    let source = ImageSource(url: url, options: nil)

    guard let extractedProperties = source?.propertiesForImage() else {
      XCTFail("We created image without properties.");
      return
    }

    guard let extractedImageEXIFImageProperties = extractedProperties.get(EXIFImageProperties.self) else {
      XCTFail("EXIF not available")
      return
    }

    XCTAssertEqual(extractedImageEXIFImageProperties.exposureTime, exposureTime)
  }

  func testGPSProperties() {
    let source = ImageSource(url: jpgWithExifImageURL, options: nil)
    guard var properties = source?.propertiesForImage() else {
      XCTFail("We created image without properties.");
      return
    }

    guard let gpsProperties = properties.get(GPSImageProperties.self) else {
      XCTFail("GPS Not available")
      return
    }
    XCTAssertEqual(gpsProperties.longitudeRef, GPSImageProperties.LongitudeRef.east)
    XCTAssertEqual(gpsProperties.latitudeRef, GPSImageProperties.LatitudeRef.north)

    properties.mutate { (gpsProperties: inout GPSImageProperties?) in
      gpsProperties?.latitudeRef = .south
    }
    XCTAssert(properties.get(GPSImageProperties.self)?.latitudeRef == .south)
  }
  
  #if canImport(UIKit)
  func testMakeGIF() {
    let savePath = makeSavePath(fileExt: "gif")
    do {
      let gifMaker = GIF()
      try gifMaker.makeGIF(fromAnimatedImage: sampleAnimatedImage,
                           writeTo: savePath,
                           properties: GIF.Properties(loopCount: 1),
                           frameProperties: GIF.FrameProperties(delayTime: 0.1))
      XCTAssert(FileManager.default.fileExists(atPath: savePath))
      let gifSource = ImageSource(data: try! Data(contentsOf: URL(fileURLWithPath: savePath)), options: nil)
      XCTAssert(gifSource!.UTI! == kUTTypeGIF)
    }
    catch {
      print(error)
    }
  }
  #endif
}


private extension Tests {
  func cgImage(at url: URL) -> CGImage {
    #if os(OSX)
    let image = NSImage(contentsOfFile: pngImageURL.path)!
    var imageRect:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    return image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
    #else
    return UIImage(contentsOfFile: pngImageURL.path)!.cgImage!
    #endif
  }

  var pngImageURL: URL {
    return bundle.url(forResource: "sample", withExtension: "png")!
  }
  
  var gifImageURL: URL {
    return bundle.url(forResource: "gifSample", withExtension: "gif")!
  }
  
  var jpgImageURL: URL {
    return bundle.url(forResource: "cameraSample", withExtension: "jpg")!
  }

  var jpgWithExifImageURL: URL {
    return bundle.url(forResource: "image_with_gps_data", withExtension: "jpg")!
  }

  #if canImport(UIKit)
  var sampleAnimatedImage: UIImage {
    var images = Array<UIImage>()
    for i in 0...10 {
      images.append(UIImage(named: "giphy\(i)", in: Bundle(for: Tests.self), compatibleWith: nil)!)
    }
    return UIImage.animatedImage(with: images, duration: 1)!
  }
  #endif
  
  func makeSavePath(fileExt: String) -> String {
    return (FileManager.default.urls(for: .cachesDirectory,
                                     in: .userDomainMask).first!.path as NSString).appendingPathComponent("\(UUID().uuidString).\(fileExt)")
  }
}
