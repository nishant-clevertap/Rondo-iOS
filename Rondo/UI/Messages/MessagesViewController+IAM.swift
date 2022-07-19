//
//  MessagesViewController+IAM.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Eureka

extension MessagesViewController {
    func buildIAM() {
        form.removeAll()
        buildTemplateMessages()
        buildActions()
        buildRichMessages()
    }
    
    func buildTemplateMessages() {
        let section = Section("In-App Messages")
        
        section <<< LabelRow {
            $0.title = "Alert"
            $0.tag = "alert"
        }
        section <<< LabelRow {
            $0.title = "Center Popup"
            $0.tag = "centerPopup"
        }
        section <<< LabelRow {
            $0.title = "Confirm"
            $0.tag = "confirm"
        }
        section <<< LabelRow {
            $0.title = "Interstitial"
            $0.tag = "interstitial"
        }
        section <<< LabelRow {
            $0.title = "Web Interstitial"
            $0.tag = "webInterstitial"
        }
        section <<< LabelRow {
            $0.title = "Ads Pre-Permission"
            $0.tag = "adsAskToAsk"
        }
        
        form +++ section
    }
    
    func buildActions() {
        let section = Section("Actions")
        
        section <<< LabelRow {
            $0.title = "Open URL"
            $0.tag = "openURL"
        }
        section <<< LabelRow {
            $0.title = "Request App Rating"
            $0.tag = "appRating"
        }
        section <<< LabelRow {
            $0.title = "Register for Push"
            $0.tag = "registerPush"
        }
        section <<< LabelRow {
            $0.title = "Register for Ads Tracking"
            $0.tag = "registerAdsTracking"
        }
        
        form +++ section
    }
    
    func buildRichMessages() {
        let section = Section("Rich In-App Messaging")
        
        section <<< LabelRow {
            $0.title = "Banner"
            $0.tag = "banner"
        }
        section <<< LabelRow {
            $0.title = "Rich Interstitial"
            $0.tag = "richInterstitial"
        }
        section <<< LabelRow {
            $0.title = "Star Rating"
            $0.tag = "starRating"
        }
        
        form +++ section
    }
}
