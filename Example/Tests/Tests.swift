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
  
  func testSupportedIdentifiers() {
    let identifiers = ImageIO.supportedUTIs()
    
    XCTAssert(identifiers.contains("public.png"), "")
    
    for identifier in identifiers {
      XCTAssertTrue(ImageIO.supportsUTI(identifier))
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
