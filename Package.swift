// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyServer",
    products: [
        .executable(
            name: "SwiftyServer",
            targets:  ["SwiftyServer", "RouterController","Data", "Classes"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .exact("2.3.0")),
        .package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", .exact("3.1.1")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("0.8.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .exact("4.1.0"))
    ],
    targets: [
        .target(
            name: "SwiftyServer",
            dependencies: ["Kitura", "RouterController", "Data"]),
        .target(
            name: "RouterController",
            dependencies: ["Kitura", "PerfectPostgreSQL", "Classes", "Data", "CryptoSwift","SwiftyJSON"]),
        .target(
        name: "Data",
            dependencies: ["PerfectPostgreSQL", "Classes"]),
        .target(
            name: "Classes"),
    ]
)
