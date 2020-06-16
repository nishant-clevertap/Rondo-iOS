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
                    Leanplum.track(event: row.tag!)
                }
            }
        }
        
        addSegmentedControl()
        buildIAM()
    }

    func requestSystemPushPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if let error = error {
                // Handle the error here.
            }

            // Enable or disable features based on the authorization.
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
    }

    func buildPush() {
        form.removeAll()

        buildPushPermissions()
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
