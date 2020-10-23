//
//  AdsTrackingManager.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 23.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import AdSupport

class AdsTrackingManager {
    
    static var advertisingIdentifierString:String {
        get {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    static func isAdvertisingTrackingEnabled() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus == ATTrackingManager.AuthorizationStatus.authorized
        }
        
        if #available(iOS 10, *) {
            return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        }
        
        return false
    }
    
    static func showNativeAdsPrompt() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch (status) {
                case ATTrackingManager.AuthorizationStatus.authorized:
                    let idfa = advertisingIdentifierString
                    NSLog("Authorized. Advertising ID is: %@. Use setDeviceId to set idfa now.", idfa);
                    Leanplum.setDeviceId(idfa)
                    break;
                case ATTrackingManager.AuthorizationStatus.notDetermined:
                    NSLog("NotDetermined");
                    break;
                    
                case ATTrackingManager.AuthorizationStatus.restricted:
                    NSLog("Restricted");
                    break;
                    
                case ATTrackingManager.AuthorizationStatus.denied:
                    NSLog("Denied");
                    break;
                    
                default:
                    NSLog("Unknown");
                    break;
                }
            })
        }
    }
}
