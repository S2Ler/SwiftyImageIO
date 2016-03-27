import UIKit
import XCTest
import SwiftyImageIO

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
    
    XCTAssert(identifiers.contains("public.png"), "")
    
    for identifier in identifiers {
      XCTAssertTrue(ImageSource.supportsUTI(identifier))
    }
  }
  
  func testDestinationSupportedIdentifiers() {
    let identifiers = ImageDestination.supportedUTIs()
    
    XCTAssert(identifiers.contains("public.png"), "")
    
    for identifier in identifiers {
      XCTAssertTrue(ImageDestination.supportsUTI(identifier))
    }
  }

  func testGifImageSource() {
    let imageSource = ImageSource(url: gifImageURL, options: nil)!
    XCTAssert(imageSource.imageCount == 120)
    XCTAssert(imageSource.status == .StatusComplete)
    for imageIndex in (0..<imageSource.imageCount) {
      XCTAssertNotNil(imageSource.createImage(atIndex: imageIndex, options: nil))
    }
    XCTAssert(imageSource.UTI! == "com.compuserve.gif")
  }
  
  func testPngImageSource() {
    let imageSource = ImageSource(url: pngImageURL, options: [.TypeIdentifierHint(UTI: "public.png")])!
    XCTAssert(imageSource.imageCount == 1)
    XCTAssert(imageSource.status == .StatusComplete)
    XCTAssertNotNil(imageSource.createImage())
    XCTAssert(imageSource.UTI! == "public.png")
  }
}

extension Tests {
  private var pngImageURL: NSURL {
    let bundle = NSBundle(forClass: self.dynamicType)
    return bundle.URLForResource("sample", withExtension: "png")!
  }
  
  private var gifImageURL: NSURL {
    let bundle = NSBundle(forClass: self.dynamicType)
    return bundle.URLForResource("gifSample", withExtension: "gif")!
  }
  
  private var jpgImageURL: NSURL {
    let bundle = NSBundle(forClass: self.dynamicType)
    return bundle.URLForResource("cameraSample", withExtension: "jpg")!
  }
}
