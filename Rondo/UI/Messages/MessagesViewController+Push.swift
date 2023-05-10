//
//  MessagesViewController+Push.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Eureka

extension MessagesViewController {
    func buildPush() {
        form.removeAll()
        
        buildPushPermissions()
        buildPushTriggers()
        buildCleverTapPush()
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
        
        section <<< LabelRow {
            $0.title = "Provisional Push"
            $0.tag = "provisionalPush"
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
            $0.title = "Local Push with Cancel"
            $0.tag = "pushLocalCancel"
        }
        section <<< LabelRow {
            $0.title = "Cancel Local Push with Cancel"
            $0.tag = "Cancel"
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
    
    func buildCleverTapPush() {
        let section = Section("CleverTap Push")
        
        section <<< SwitchRow {
            $0.title = "Open DeepLinks In Foreground"
            $0.value = false
        }.onChange({ row in
            Leanplum.setCleverTapOpenDeepLinksInForeground(row.value!)
        })
        
        section <<< SwitchRow {
            $0.title = "Handle CleverTap Notification"
            $0.value = false
        }.onChange({ row in
            Leanplum.setHandleCleverTapNotification { (userInfo, isNotificationOpen, block) in
                Log.print("CleverTap handle push block: \(userInfo), isNotificationOpen: \(isNotificationOpen)")
                block()
            }
        })
        
        form +++ section
    }
}
