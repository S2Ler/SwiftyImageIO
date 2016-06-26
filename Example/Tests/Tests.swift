#if os(OSX)
  import AppKit
#else
  import UIKit
#endif
import XCTest
import SwiftyImageIO
#if !os(OSX)
  import MobileCoreServices
#endif
import Foundation

class Tests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
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
    let imageSource = ImageSource(url: pngImageURL, options: [.typeIdentifierHint(kUTTypePNG)])!
    XCTAssert(imageSource.imageCount == 1)
    XCTAssert(imageSource.status == .statusComplete)
    XCTAssertNotNil(imageSource.createImage())
    XCTAssert(imageSource.UTI! == kUTTypePNG)
  }
  
  func testImageDestination() {
    let data = NSMutableData()

    guard let destination = ImageDestination(data: data, UTI: kUTTypePNG, imageCount: 1)
      else { XCTAssert(false); return }
    #if os(OSX)
      let image = NSImage(contentsOfFile: pngImageURL.path!)!
      var imageRect:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      let cgimage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
    #else
      let cgimage: CGImage = UIImage(contentsOfFile: pngImageURL.path!)!.cgImage!
    #endif
    
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
  
  func testMakeGIF() {
    let savePath = makeSavePath(fileExt: "gif")
    do {
      let gifMaker = GIF()
      try gifMaker.makeGIF(fromAnimatedImage: sampleAnimatedImage,
                           writeTo: savePath,
                           gifProperties: [.DelayTime(0.1), .LoopCount(1)])
      XCTAssert(FileManager.default().fileExists(atPath: savePath))
      let gifSource = ImageSource(data: try! Data(contentsOf: URL(fileURLWithPath: savePath)), options: nil)
      XCTAssert(gifSource!.UTI! == kUTTypeGIF)
    }
    catch {
      print(error)
    }
  }
}


extension Tests {
  private var pngImageURL: URL {
    let bundle = Bundle(for: self.dynamicType)
    return bundle.urlForResource("sample", withExtension: "png")!
  }
  
  private var gifImageURL: URL {
    let bundle = Bundle(for: self.dynamicType)
    return bundle.urlForResource("gifSample", withExtension: "gif")!
  }
  
  private var jpgImageURL: URL {
    let bundle = Bundle(for: self.dynamicType)
    return bundle.urlForResource("cameraSample", withExtension: "jpg")!
  }
  
  private var sampleAnimatedImage: UIImage {
    var images = Array<UIImage>()
    for i in 0...10 {
      images.append(UIImage(named: "giphy\(i)", in: Bundle(for: Tests.self), compatibleWith: nil)!)
    }
    return UIImage.animatedImage(with: images, duration: 1)!
  }
  
  func makeSavePath(fileExt: String) -> String {
    return (FileManager.default().urlsForDirectory(.cachesDirectory,
                                           inDomains: .userDomainMask).first!.path! as NSString!).appendingPathComponent("\(UUID().uuidString).\(fileExt)")
  }
}
