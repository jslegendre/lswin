// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "lswin",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "lswin", targets: ["lswin"]),
        .executable(name: "install", targets: ["install"]),
        .executable(name: "uninstall", targets: ["uninstall"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.2"),
    ],
    targets: [
        .executableTarget(
            name: "lswin",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "lswin"),
        .executableTarget(
            name: "install",
            path: "Tasks/Install"),
        .executableTarget(
            name: "uninstall",
            path: "Tasks/Uninstall"),
    ]
)
