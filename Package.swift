// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MUDKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "MUDKit", targets: ["MUDKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Pulse", exact: "5.1.3"),
        .package(url: "https://github.com/Alamofire/Alamofire", exact: "5.10.2"),
        .package(url: "https://github.com/evgenyneu/keychain-swift", exact: "24.0.0")
    ],
    targets: [
        .target(
            name: "MUDKit",
            dependencies: [
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "PulseProxy", package: "Pulse"),
                .product(name: "PulseUI", package: "Pulse"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "KeychainSwift", package: "keychain-swift")
            ]
        )
    ]
)
