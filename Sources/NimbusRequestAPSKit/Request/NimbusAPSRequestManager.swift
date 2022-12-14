//
//  NimbusAPSRequestManager.swift
//  NimbusRequestAPSKit
//
//  Created by Inder Dhir on 7/14/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import DTBiOSSDK
@_exported import NimbusRequestKit

public protocol APSRequestManagerType {
    var usPrivacyString: String? { get set }
    func loadAdsSync(for adSizes: [DTBAdSize]) -> [[AnyHashable: Any]]
}


final class NimbusAPSRequestManager: APSRequestManagerType {
    private let requestsDispatchGroup = DispatchGroup()
    private let requestsTimeoutInSeconds: Double
    private let logger: Logger
    private let logLevel: NimbusLogLevel
    private var adLoadersDict: [String: DTBAdLoader] = [:]
    var usPrivacyString: String?

    init(
        appKey: String,
        logger: Logger,
        logLevel: NimbusLogLevel,
        timeoutInSeconds: Double = 0.5,
        enableTestMode: Bool = false
    ) {
        self.logger = logger
        self.logLevel = logLevel
        self.requestsTimeoutInSeconds = timeoutInSeconds
        
        DTBAds.sharedInstance().setAppKey(appKey)
        DTBAds.sharedInstance().mraidPolicy = CUSTOM_MRAID
        DTBAds.sharedInstance().mraidCustomVersions = ["1.0", "2.0", "3.0"]
        DTBAds.sharedInstance().setLogLevel(logLevel.apsLogLevel)
        DTBAds.sharedInstance().testMode = enableTestMode
    }
    
    func loadAdsSync(for adSizes: [DTBAdSize]) -> [[AnyHashable: Any]] {
        var callbacks: [DTBCallback] = []
        adSizes.forEach { adSize in
            let adLoader = reuseOrCreateAdLoader(for: adSize)
            
            requestsDispatchGroup.enter()
            let callback = DTBCallback(loaders: adLoadersDict, requestsDispatchGroup: requestsDispatchGroup)
            callbacks.append(callback)
            adLoader.loadAd(callback)
        }
        
        let result = requestsDispatchGroup.wait(timeout: .now() + requestsTimeoutInSeconds)
        switch result {
        case .success:
            logger.log("APS requests completed successfully", level: logLevel)
        case .timedOut:
            logger.log("APS requests timed out", level: logLevel)
        }
        
        return callbacks.compactMap { $0.payload }
    }
    
    private func reuseOrCreateAdLoader(for adSize: DTBAdSize) -> DTBAdLoader {
        if let existingAdLoader = adLoadersDict.removeValue(forKey: adSize.slotUUID) {
            return existingAdLoader
        }
        
        let adLoader = DTBAdLoader()
        adLoader.setAdSizes([adSize as Any])
        if let usPrivacyString = usPrivacyString {
            adLoader.putCustomTarget(usPrivacyString, withKey: "us_privacy")
        }
        
        return adLoader
    }
}

// MARK: DTBAdCallback

/// :nodoc:
final class DTBCallback: DTBAdCallback {
    
    private let requestsDispatchGroup: DispatchGroup
    private var adLoadersDict: [String: DTBAdLoader]
    var payload: [AnyHashable: Any]?
    
    init(loaders: [String: DTBAdLoader], requestsDispatchGroup: DispatchGroup) {
        self.adLoadersDict = loaders
        self.requestsDispatchGroup = requestsDispatchGroup
    }

    /// :nodoc:
    public func onFailure(_ error: DTBAdError) {
        Nimbus.shared.logger.log("APS ad fetching failed with code: \(error.rawValue)", level: .error)
        
        requestsDispatchGroup.leave()
    }

    /// :nodoc:
    public func onSuccess(_ adResponse: DTBAdResponse!) {
        Nimbus.shared.logger.log("APS ad fetching succeeded", level: .debug)
        adLoadersDict[adResponse.adSize().slotUUID] = adResponse.dtbAdLoader
        payload = adResponse.customTargeting()
        requestsDispatchGroup.leave()
    }
}
