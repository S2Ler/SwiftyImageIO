import ImageIO

//TODO: Copy/Paste documentation from ImageIO

public final class ImageDestination {
  public static func supportedUTIs() -> [String] {
    let identifiers = CGImageDestinationCopyTypeIdentifiers() as [AnyObject] as! [String]
    return identifiers
  }
  
  public static func supportsUTI(UTI: String) -> Bool {
    return supportedUTIs().contains(UTI)
  }
}

