// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Notarize",
    products: [
        .executable(name: "notarize", targets: ["Notarize"]),
        .library(name: "NotarizeKit", targets: ["NotarizeKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.7.0"),
    ],
    targets: [
        .target(name: "Notarize", dependencies: [
            "NotarizeKit",
            "Rainbow",
        ]),
        .target(name: "NotarizeKit", dependencies: [
            "Rainbow",
            "SWXMLHash",
        ]),
        .testTarget(name: "NotarizeTests", dependencies: [
            "NotarizeKit",
            "Rainbow",
            "SWXMLHash",
        ]),
    ]
)
