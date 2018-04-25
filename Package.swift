// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyServer",
    products: [
        .executable(
            name: "SwiftyServer",
            targets:  ["SwiftyServer", "RouterController","Data", "LogicalClasses"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", from: "3.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("0.8.0"))
    ],
    targets: [
        .target(
            name: "SwiftyServer",
            dependencies: ["Kitura", "RouterController", "Data"]),
        .target(
            name: "RouterController",
            dependencies: ["Kitura", "PerfectPostgreSQL", "LogicalClasses", "Data", "CryptoSwift"]),
        .target(
        name: "Data",
            dependencies: ["PerfectPostgreSQL", "LogicalClasses"]),
        .target(
            name: "LogicalClasses"),
    ]
)
