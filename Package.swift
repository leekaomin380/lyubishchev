// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Lyubishchev",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "Lyubishchev",
            path: "Sources"
        )
    ]
)
