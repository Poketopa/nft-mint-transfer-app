// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkingKitJWT",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "NetworkingKitJWT", targets: ["NetworkingKitJWT"])
    ],
    targets: [
        .target(name: "NetworkingKitJWT",
                path: "Sources/NetworkingKitJWT"),
        .testTarget(name: "NetworkingKitJWTTests",
                    dependencies: ["NetworkingKitJWT"])
    ]
)
