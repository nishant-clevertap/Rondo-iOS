//
//  AdsTrackingActionTemplate.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 16.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import Foundation
import Leanplum
import AppTrackingTransparency
import AdSupport

class AdsTrackingActionTemplate: LPMessageTemplateProtocol {
    var context: ActionContext
    
    init(context:ActionContext) {
        self.context = context
    }
    
    static func defineAction() {
        let name = "Register for Ads Tracking"
        
        Leanplum.defineAction(name: name, kind: .action,
                              args: [],
                              completion: { context in
                                if #available(iOS 14, *) {
                                    if ATTrackingManager.trackingAuthorizationStatus == ATTrackingManager.AuthorizationStatus.notDetermined {
                                        AdsTrackingManager.showNativeAdsPrompt()
                                        return true
                                    }
                                    // Open the App Settings if the user has already declined tracking
                                    if ATTrackingManager.trackingAuthorizationStatus == ATTrackingManager.AuthorizationStatus.denied,
                                       let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        return true
                                    }
                                }
                                return false
        })
    }
}
