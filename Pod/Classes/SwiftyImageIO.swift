import ImageIO
import MobileCoreServices

public final class ImageIO {
  public typealias UnifersalTypeIdentifier = String
  
  public static func supportedUTIs() -> [UnifersalTypeIdentifier] {
    let identifiers = CGImageSourceCopyTypeIdentifiers() as! [AnyObject] as! [UnifersalTypeIdentifier]
    return identifiers
  }
  
  public static func supportsUTI(UTI: UnifersalTypeIdentifier) -> Bool {
    return supportedUTIs().contains(UTI)
  }
}
