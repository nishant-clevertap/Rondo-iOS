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
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.selectionStyle = .none
            row.onChange { [weak self] (row) in
                guard let self = self, let value = row.value else { return }
                self.setUNUserNotificationCenterDelegate(on: value)
            }
            row.onCellSelection { (cell, row) in
                guard let value = row.value else { return }
                row.value = !value
                cell.update()
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
        buildDeferIAMs()
        buildActions()
        buildRichMessages()
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
            $0.value = UserDefaults.standard.bool(forKey: "deferIAM")
        }.onChange { [weak self] (row) in
            guard let self = self, let value = row.value else { return }
            self.toggleDeferMessages(on: value)
        }
        
        section <<< AccountRow {
            $0.title = "Action Names"
            $0.placeholder = "alert,confirm,html"
        }
        
        section <<< AccountRow {
            $0.title = "View Controllers"
            $0.placeholder = "home,variables,inbox"
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
            self.deferMessages(names: names, forControllers: controllers)
        }
        
        form +++ section
    }
    
    private func deferMessages(names: [String], forControllers: [String]) {
        if names.count > 0 {
            var actionNames:[String] = []
            
            names.forEach {
                let lc = $0.lowercased()
                switch lc {
                case "alert": actionNames.append("Alert")
                case "confirm": actionNames.append("Confirm")
                case "push": actionNames.append("Push Ask to Ask")
                case "popup": actionNames.append("Center Popup")
                case "int": actionNames.append("Interstitial")
                case "webint": actionNames.append("Web Interstitial")
                case "html": actionNames.append("HTML")
                default: ()
                }
            }
            
            Leanplum.deferMessagesWithActionNames(actionNames)
        }
        if forControllers.count > 0 {
            var controllerTypes:[AnyClass] = []
            
            forControllers.forEach {
                let className = "Rondo_iOS.\(capitalizeFirstLetter(word: $0))ViewController"
                    if let aClass = NSClassFromString(className) as? UIViewController.Type {
                        controllerTypes.append(aClass)
                    }
            }
            
            if controllerTypes.count > 0 {
                Leanplum.deferMessagesForViewControllers(controllerTypes)
                
                let section = form.sectionBy(tag: "Defer IAM")
                let row = section?.first(where: {$0 as? SwitchRow != nil}) as! SwitchRow
                row.value = true
                row.reload()
            }
        }
    }
    
    private func capitalizeFirstLetter(word:String) -> String {
        let first = String(word.prefix(1)).capitalized
                let other = String(word.dropFirst())
                return first + other
    }
    
    private func toggleDeferMessages(on: Bool) {
        if on {
            Leanplum.deferMessagesForViewControllers([HomeViewController.self])
        } else {
            Leanplum.deferMessagesWithActionNames([])
            Leanplum.deferMessagesForViewControllers([])
        }
        UserDefaults.standard.set(on, forKey: "deferIAM")
        //UserDefaults.standard.useUNUserNotificationCenterDelegate = on
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
