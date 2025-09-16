// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteEventStore",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "RemoteEventStore",
            targets: ["RemoteEventStore"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "RemoteEventStore",
            dependencies: [
                "SharedModels", 
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "RemoteEventStoreTests",
            dependencies: ["RemoteEventStore"]
        ),
    ]
)
