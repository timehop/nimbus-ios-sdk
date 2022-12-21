// swift-tools-version: 5.6

import PackageDescription
import Foundation

let package = Package(
    name: "NimbusSDK",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "NimbusKit",
            targets: ["NimbusKit", "NimbusRenderKit", "NimbusRequestKit", "NimbusCoreKit"]),
        .library(
            name: "NimbusRenderKit",
            targets: ["NimbusRenderKit", "NimbusCoreKit"]),
        .library(
            name: "NimbusRenderStaticKit",
            targets: [
                "NimbusRenderKit",
                "NimbusRenderStaticKit",
                "NimbusCoreKit",
            ]),
        .library(
            name: "NimbusRenderVideoKit",
            targets: [
                "NimbusRenderKit",
                "NimbusRenderVideoKit",
                "NimbusCoreKit",
            ]),
        .library(
            name: "NimbusRequestKit",
            targets: ["NimbusRequestKit", "NimbusCoreKit"]),
        .library(
            name: "NimbusGAMKit",
            targets: ["NimbusGAMKit"]),
        .library(
            name: "NimbusFANKit",
            targets: ["NimbusFANKit"]),
        .library(
            name: "NimbusLiveRampKit",
            targets: ["NimbusLiveRampKit"]),
        .library(
            name: "NimbusRenderOMKit",
            targets: ["NimbusRenderOMKit"]),
        .library(
            name: "NimbusRequestAPSKit",
            targets: ["NimbusRequestAPSKit"]),
        .library(
            name: "NimbusUnityKit",
            targets: ["NimbusUnityKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/faktorio/ats-sdk-ios-prod", from: "1.4.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "9.12.0"),
        .package(url: "https://github.com/timehop/nimbus-ios-dependencies", branch: "main"),
    ],
    targets: [
        .target(
            name: "NimbusGAMKit",
            dependencies: [
                "NimbusKit",  "NimbusCoreKit",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")]),
        .testTarget(
            name: "NimbusGAMKitTests",
            dependencies: ["NimbusGAMKit"]),
        .target(
            name: "NimbusLiveRampKit",
            dependencies: [
                "NimbusRequestKit", "NimbusCoreKit",
                .product(name: "LRAtsSDK", package: "ats-sdk-ios-prod")]),
        .testTarget(
            name: "NimbusLiveRampKitTests",
            dependencies: ["NimbusLiveRampKit"]),
        .target(
            name: "NimbusFANKit",
            dependencies: ["NimbusRenderKit", "NimbusRequestKit", "NimbusCoreKit", .product(name: "FBAudienceNetwork", package: "nimbus-ios-dependencies")]),
        .testTarget(
            name: "NimbusFANKitTests",
            dependencies: ["NimbusFANKit"]),
        .target(
            name: "NimbusRequestAPSKit",
            dependencies: ["NimbusRequestKit", "NimbusCoreKit", .product(name: "DTBiOSSDK", package: "nimbus-ios-dependencies")]),
        .testTarget(
            name: "NimbusRequestAPSKitTests",
            dependencies: ["NimbusRequestAPSKit"]),
        .target(
            name: "NimbusUnityKit",
            dependencies: ["NimbusRenderKit", "NimbusRequestKit", "NimbusCoreKit", .product(name: "DTBiOSSDK", package: "nimbus-ios-dependencies")]),
        .testTarget(
            name: "NimbusUnityKitTests",
            dependencies: ["NimbusUnityKit"]),
    ]
)

let sdkPath = Context.environment["NIMBUS_IOS_PATH"] ?? "nimbus-ios"

if FileManager.default.fileExists(atPath: sdkPath) {
    package.targets += [
        .target(name: "NimbusCoreKit", path: sdkPath + "/Sources/NimbusCoreKit"),
        .target(name: "NimbusRenderKit",
            dependencies: ["NimbusCoreKit"],
            path: sdkPath + "/Sources/NimbusRenderKit"),
        .target(name: "NimbusRenderOMKit",
            dependencies: ["NimbusRenderKit", "OMSDKAdsbynimbus"],
            path: sdkPath + "/Sources/NimbusRenderOMKit"),
        .target(name: "NimbusRenderStaticKit",
            dependencies: ["NimbusRenderKit"],
            path: sdkPath + "/Sources/NimbusRenderStaticKit"),
        .target(name: "NimbusRenderVideoKit",
            dependencies: ["NimbusRenderKit", "GoogleInteractiveMediaAds"],
            path: sdkPath + "/Sources/NimbusRenderVideoKit"),
        .target(name: "NimbusRequestKit",
            dependencies: ["NimbusCoreKit"],
            path: sdkPath + "/Sources/NimbusRequestKit"),
        .target(name: "NimbusKit",
            dependencies: ["NimbusRequestKit", "NimbusRenderKit"],
            path: sdkPath + "/Sources/NimbusKit"),
    ]
} else {
    package.targets += [
        .binaryTarget(
            name: "NimbusKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusKit-2.1.2.zip",
            checksum: "0ae72204b6fcf48433d4e00d95342bbc0dafbc98a3b3942453cc77e2f8ef3e5b"),
        .binaryTarget(
            name: "NimbusRequestKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusRequestKit-2.1.2.zip",
            checksum: "d4d7f53a721ff9a43a6d2c67c894a502ea63eb9cc57d8284843742210ee7b331"),
        .binaryTarget(
            name: "NimbusRenderKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusRenderKit-2.1.2.zip",
            checksum: "2b58b9a2f2c972896d66611e229709a5fdcc08490595014d996af7e61e70cafc"),
        .binaryTarget(
            name: "NimbusRenderStaticKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusRenderStaticKit-2.1.2.zip",
            checksum: "a96f96f1c47012f2f0def93d9532de87407d48155df967e6f2cf3b43f1170462"),
        .binaryTarget(
            name: "NimbusRenderVideoKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusRenderVideoKit-2.1.2.zip",
            checksum: "4747ddbb4632bf425b4d3282edd72d5f01111c611a95a781090bf99d3f0efafa"),
        .binaryTarget(
            name: "NimbusRenderOMKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusRenderOMKit-2.1.2.zip",
            checksum: "ca0c2eccafabbee1123d69bd6511213267cbd4b8be9822407e1d04e408d7db9f"),
        .binaryTarget(
            name: "NimbusCoreKit",
            url: "https://adsbynimbus-public.s3.amazonaws.com/iOS/sdks/2.1.2/NimbusCoreKit-2.1.2.zip",
            checksum: "6f631fd8dfe5ca38e04629def85660724224ff6b6ff390f93cdd88df0d19e547"),
    ]
}
