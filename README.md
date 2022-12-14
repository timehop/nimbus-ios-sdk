# Nimbus iOS SDK

Welcome to Nimbus - ads by publishers, for publishers.

## Introduction

Nimbus iOS now offers preliminary support for Swift Package Manager. 

Documentation can be found at https://docs.adsbynimbus.com/docs/sdk/ios

## Requirements

- Xcode 13.3 or above

## Setup

1. Navigate to Frameworks, Libraries, and Embedded Content for an iOS application target 
2. Click the + button and select Add Package Dependency... under the Add Other dropdown
3. Enter https://github.com/timehop/nimbus-ios-sdk in the package URL and select the main branch
4. Select all the frameworks required by your integration type

### Nimbus Standalone

- NimbusKit: The main framework of the Nimbus SDK
- NimbusRenderKit: Adds support for rendering Nimbus Ads
  - NimbusRenderStaticKit: Renderer for Nimbus static ads (display / banner ads)
  - NimbusRenderVideoKit: Renderer for Nimbus video ads
  - NimbusRenderOMKit: Enables viewability measurement using the Open Measurement SDK
- NimbusRequestKit - Adds support for making requests to Nimbus

### Nimbus Extensions

- [NimbusFANKit](Sources/NimbusFANKit): Adds support for Meta Audience Network ads
- [NimbusGAMKit](Sources/NimbusGAMKit): Mediation adapters and Dynamic Price support for Google Ad Manager
- [NimbusLiveRampKit](Sources/NimbusLiveRampKit): Adds support for passing IDs using the LiveRamp SDK 
- [NimbusRequestAPSKit](Sources/NimbusRequestAPSKit): Adds support for including Amazon demand in the Nimbus auction
- [NimbusUnityKit](Sources/NimbusUnityKit): Adds support for Unity Rewarded Video Ads

### Nimbus Dynamic Price

Only NimbusKit and NimbusGAMKit are required for a Dynamic Price integration. For additional information integrating
Dynamic Price please see our [documentation](https://docs.adsbynimbus.com/docs/sdk/dynamic-price).

## License

Copyright 2022 Timehop Inc. Distributed under [GNU GPLv3](LICENSE).
