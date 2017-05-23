// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftyImageIO",
    products: [
        .library(name: "SwiftyImageIO", targets: ["SwiftyImageIO"]),
    ],
    targets: [
        .target(
            name: "SwiftyImageIO",
            path: "Sources"
        ),
        // NOTE: Tests in SPM not supported due to missing bundle support
        //  .testTarget(
        //      name: "SwiftyImageIOTests",
        //      dependencies: ["SwiftyImageIO"],
        //      path: "Example/Tests"
        // ),
    ],
    swiftLanguageVersions: [.v5]
)
