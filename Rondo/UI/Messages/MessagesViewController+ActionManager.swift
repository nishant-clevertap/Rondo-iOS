//
//  MessagesViewController+ActionManager.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Eureka

extension MessagesViewController {
    func buildActionManager() {
        form.removeAll()
        
        buildQueueOptions()
        buildMessageDisplayHandlers()
        buildOnMessage()
    }
    
    func buildQueueOptions() {
        let section = Section("Action Manager Configuration")
        
        section <<< SwitchRow {
            $0.title = "Pause Queue"
            $0.value = self.model.isQueuePaused
        }.onChange({ row in
            self.model.isQueuePaused = row.value!
        })
        section <<< SwitchRow {
            $0.title = "Disable Queue"
            $0.value = !self.model.isQueueEnabled
        }.onChange({ row in
            self.model.isQueueEnabled = !row.value!
        })
        section <<< SwitchRow {
            $0.title = "Dismiss on Push Opened"
            $0.value = self.model.dismissOnPushArrival
        }.onChange({ row in
            self.model.dismissOnPushArrival = row.value!
        })
        section <<< SwitchRow {
            $0.title = "Resume on App Foreground"
            $0.value = self.model.resumeOnEnterForeground
        }.onChange({ row in
            self.model.resumeOnEnterForeground = row.value!
        })
        
        section <<< ButtonRow {
            $0.title = "View Queue"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                self.model.showMessageQueue()
            }), onDismiss: nil)
        }
        
        form +++ section
    }
    
    func buildMessageDisplayHandlers() {
        let section = SelectableSection<ListCheckRow<MessageDisplay>>("Should Display Message",
                                                                      selectionType: .singleSelection(enableDeselection: true))
        
        let options = MessageDisplay.allCases
        for option in options {
            section <<< ListCheckRow<MessageDisplay>(option.rawValue){ listRow in
                listRow.title = option.rawValue
                listRow.tag = option.rawValue
                listRow.selectableValue = option
                listRow.value = nil
            }
        }
        
        form +++ section
        
        let defaultDelay = 5
        let delaySection = Section() {
            $0.hidden = Condition.function([MessageDisplay.delay.rawValue], { form in
                let row = form.rowBy(tag: MessageDisplay.delay.rawValue) as? ListCheckRow<MessageDisplay>
                if row?.value != nil {
                    return false
                }
                return true
            })
        }
        <<< IntRow(){
            $0.title = "Delay Seconds"
            $0.tag = "delaySeconds"
            $0.value = defaultDelay
        }
        <<< ButtonRow(){
            $0.title = "Set"
        }.onCellSelection({ [weak self] cell, row in
            let secondsRow = self?.form.rowBy(tag: "delaySeconds") as? IntRow
            self?.model.delaySeconds = secondsRow?.value ?? defaultDelay
        })
        
        form +++ delaySection
        
        form +++ Section()
        <<< ButtonRow {
            $0.title = "View Delayed Queue"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                self.model.showDelayedMessageQueue()
            }), onDismiss: nil)
        }
        <<< ButtonRow(){
            $0.title = "Trigger Delayed Messages"
        }.onCellSelection({ [weak self] cell, row in
            self?.model.triggerDelayedMessages()
        })
        
        let prioritySection = SelectableSection<ListCheckRow<MessagePrioritization>>("Prioritize Messages",
                                                                                     selectionType: .singleSelection(enableDeselection: true))
        
        let prioritizeOptions = MessagePrioritization.allCases
        for option in prioritizeOptions {
            prioritySection <<< ListCheckRow<MessagePrioritization>(){ listRow in
                listRow.title = option.rawValue
                listRow.selectableValue = option
                listRow.value = nil
            }
        }
        
        form +++ prioritySection
    }
    
    func buildOnMessage() {
        let section = Section("On Message Handlers")
        
        section <<< SwitchRow {
            $0.title = "onMessageDisplayed"
            $0.value = self.model.trackMessageDisplayed
            $0.onChange { row in
                self.model.trackMessageDisplayed = row.value
            }
        }
        section <<< SwitchRow {
            $0.title = "onMessageDismissed"
            $0.value = self.model.trackMessageDismissed
            $0.onChange { row in
                self.model.trackMessageDismissed = row.value
            }
        }
        section <<< SwitchRow {
            $0.title = "onMessageAction"
            $0.value = self.model.trackMessageActions
            $0.onChange { row in
                self.model.trackMessageActions = row.value
            }
        }
        
        section <<< ButtonRow {
            $0.title = "View Event Logs"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                self.model.showEventLogs()
            }), onDismiss: nil)
        }
        section <<< ButtonRow {
            $0.title = "Delete Event Logs"
        }.onCellSelection({ cell, row in
            self.model.resetEventLogs()
        })
        
        form +++ section
    }
}
