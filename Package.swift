// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MUDKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MUDKit", targets: ["MUDKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Pulse", exact: "5.1.3")
    ],
    targets: [
        .target(name: "MUDKit"),
    ]
)
