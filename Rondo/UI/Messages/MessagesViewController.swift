//
//  MessagesViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class MessagesViewController: FormViewController {
    private let segmentedControl = UISegmentedControl(items: ["IAM", "Push"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelRow.defaultCellSetup = { cell, row in
            cell.selectionStyle = .default
            row.onCellSelection { (cell, row) in
                row.deselect(animated: true)
                if row.tag == "systemPush" {
                    self.requestSystemPushPermission()
                } else {
                    Leanplum.track(row.tag!)
                }
            }
        }
        
        addSegmentedControl()
        buildIAM()
    }
    
    private func setUNUserNotificationCenterDelegate(on: Bool) {
        if on {
            UNUserNotificationCenter.current().delegate = UIApplication.shared.appDelegate
        } else {
            UNUserNotificationCenter.current().delegate = nil
        }
        UserDefaults.standard.useUNUserNotificationCenterDelegate = on
    }
    
    func requestSystemPushPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print("Error: \(error)")
            }
            
            // Enable or disable features based on the authorization.
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func addSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(MessagesViewController.didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.sizeToFit()
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc func didChangeSegment() {
        title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        if segmentedControl.selectedSegmentIndex == 0 {
            buildIAM()
        } else {
            buildPush()
        }
    }
    
    func buildIAM() {
        form.removeAll()
        buildTemplateMessages()
        buildActions()
        buildRichMessages()
        buildDeferIAMs()
    }
    
    func buildPush() {
        form.removeAll()
        
        buildPushPermissions()
        buildSetPushDelegate()
        buildPushTriggers()
    }
    
    func buildPushPermissions() {
        let section = Section("Push Permissions")
        
        section <<< LabelRow {
            $0.title = "Push Permissions Through Leanplum"
            $0.tag = "registerPush"
        }
        
        section <<< LabelRow {
            $0.title = "System Push Permission"
            $0.tag = "systemPush"
        }
        
        form +++ section
    }
    
    func buildSetPushDelegate() {
        let section = Section("Set push notification delegate")
        
        section <<< SwitchRow {
            $0.title = "UNUserNotificationCenterDelegate"
            $0.tag = "setPushDelegate"
            $0.value = UNUserNotificationCenter.current().delegate != nil
        }.onChange { [weak self] (row) in
            guard let self = self, let value = row.value else { return }
            self.setUNUserNotificationCenterDelegate(on: value)
        }.onCellSelection { (cell, row) in
            guard let value = row.value else { return }
            row.value = !value
            cell.update()
        }
        
        form +++ section
    }
    
    func buildPushTriggers() {
        let section = Section("Push Notifications")
        
        section <<< LabelRow {
            $0.title = "Push with Emoji"
            $0.tag = "pushRender"
        }
        section <<< LabelRow {
            $0.title = "Push with Image"
            $0.tag = "pushImage"
        }
        section <<< LabelRow {
            $0.title = "Push with New IAM"
            $0.tag = "pushAction"
        }
        section <<< LabelRow {
            $0.title = "Push with Existing IAM"
            $0.tag = "pushExistingAction"
        }
        section <<< LabelRow {
            $0.title = "Push with Open URL"
            $0.tag = "pushURL"
        }
        section <<< LabelRow {
            $0.title = "Push with Text Formatting"
            $0.tag = "pushOptions"
        }
        section <<< LabelRow {
            $0.title = "Local Push"
            $0.tag = "pushLocal"
        }
        section <<< LabelRow {
            $0.title = "Muted Push"
            $0.tag = "pushMuted"
        }
        section <<< LabelRow {
            $0.title = "Local Push with Same Priority"
            $0.tag = "pushLocalSamePriorityTime"
        }
        section <<< LabelRow {
            $0.title = "Local Push with Same Priority Different Time"
            $0.tag = "pushLocalSamePriorityDifferentTime"
        }
        
        form +++ section
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
    
    func buildDeferIAMs() {
        let section = Section("Defer IAM")
        section.tag = section.header?.title
        
        section <<< SwitchRow {
            $0.title = "Defer IAM"
            $0.tag = "deferIAM"
            $0.value = UserDefaults.standard.deferIAM?.enabled
        }.onChange { [weak self] (row) in
            guard let self = self, let value = row.value else { return }
            self.toggleDeferMessages(on: value)
        }
        
        section <<< AccountRow {
            $0.title = "Action Names"
            $0.placeholder = "alert,confirm,html"
            $0.value = UserDefaults.standard.deferIAM?.actionNames.joined(separator: ",")
        }
        
        section <<< AccountRow {
            $0.title = "View Controllers"
            $0.placeholder = "home,variables,inbox"
            $0.value = UserDefaults.standard.deferIAM?.viewControllers.joined(separator: ",")
        }
        
        section <<< ButtonRow {
            $0.title = "Defer messages"
        }.onCellSelection { (cell, row) in
            
            var names:[String] = []
            if let row = section.allRows[1] as? AccountRow {
                if let val = row.value {
                names.append(contentsOf: val.components(separatedBy: ","))
                }
            }
            var controllers:[String] = []
            if let row = section.allRows[2] as? AccountRow {
                if let val = row.value {
                    controllers.append(contentsOf: val.components(separatedBy: ","))
                }
            }
            
            let df = LeanplumDeferIAM(enabled: true, actionNames: names, viewControllers: controllers)
            UserDefaults.standard.deferIAM = df
        }
        
        form +++ section
    }
    
    private func toggleDeferMessages(on: Bool) {
        var df:LeanplumDeferIAM? = nil
        if on {
            df = LeanplumDeferIAM(enabled: true, actionNames: [], viewControllers: ["home"])
        } else {
            df = LeanplumDeferIAM(enabled: false, actionNames: [], viewControllers: [])
        }
        UserDefaults.standard.deferIAM = df
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
