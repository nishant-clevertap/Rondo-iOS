//
//  ActionManagerModel.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Leanplum

enum MessageDisplay: String, CaseIterable {
    case show = "Show"
    case discard = "Discard"
    case delayIndefinitely = "DelayIndefinitely"
    case delay = "Delay"
    
    func messageDisplayChoice() -> ActionManager.MessageDisplayChoice {
        switch self {
        case .show:
            return .show()
        case .discard:
            return.discard()
        case .delayIndefinitely:
            return .delayIndefinitely()
        default:
            return .show()
        }
    }
}

enum MessagePrioritization: String, CaseIterable {
    case all = "All"
    case firstOnly = "First Only"
    case allReversed = "All Reversed"
}

struct ActionModel: Encodable {
    let name: String
    let messageId: String
    let parent: String
    let handler: String
    let actionName: String?
    
    static func description(from context: ActionContext, handler: String?, action: String?) -> String {
        let model = ActionModel(name: context.name,
                                messageId: context.messageId,
                                parent: context.parent?.messageId ?? "",
                                handler: handler ?? "",
                                actionName: action ?? "")
        return Util.jsonPrettyString(model)
    }
}

class ActionManagerModel {
    init(trackMessageDisplayed: Bool, trackMessageDismissed: Bool, trackMessageActions: Bool) {
        // invoke didSet
        defer {
            self.trackMessageDisplayed = trackMessageDisplayed
            self.trackMessageDismissed = trackMessageDismissed
            self.trackMessageActions = trackMessageActions
        }
    }
    
    convenience init() {
        self.init(trackMessageDisplayed: true, trackMessageDismissed: true, trackMessageActions: true)
    }
    
    var eventsLog = [String]()
    
    var displayChoice: MessageDisplay? {
        didSet {
            if let displayChoice = displayChoice {
                switch displayChoice {
                    // .delay with seconds is handled separately
                case .show, .discard, .delayIndefinitely:
                    ActionManager.shared.shouldDisplayMessage { _ in
                        Log.print("ShouldDisplayMessage running on main thread: \(Thread.isMainThread)")
                        return displayChoice.messageDisplayChoice()
                    }
                default:
                    break
                }
            } else {
                ActionManager.shared.shouldDisplayMessage(nil)
            }
        }
    }
    
    var prioritizationChoice: MessagePrioritization? {
        didSet {
            if oldValue != prioritizationChoice {
                prioritizationChoiceChanged(prioritizationChoice)
            }
        }
    }
    
    var delaySeconds: Int = -1 {
        didSet {
            ActionManager.shared.shouldDisplayMessage { [weak self]_ in
                return .delay(seconds: self?.delaySeconds ?? 0)
            }
        }
    }
    
    var isAsyncEnabled = ActionManager.shared.useAsyncDecisionHandlers {
        didSet {
            ActionManager.shared.useAsyncDecisionHandlers = isAsyncEnabled
        }
    }
    
    var isQueueEnabled = ActionManager.shared.isEnabled {
        didSet {
            ActionManager.shared.isEnabled = isQueueEnabled
        }
    }
    
    var isQueuePaused = ActionManager.shared.isPaused {
        didSet {
            ActionManager.shared.isPaused = isQueuePaused
        }
    }
    
    var dismissOnPushArrival = ActionManager.shared.configuration.dismissOnPushArrival {
        didSet {
            if oldValue != dismissOnPushArrival {
                applyConfiguration()
            }
        }
    }
    
    var resumeOnEnterForeground = ActionManager.shared.configuration.resumeOnEnterForeground {
        didSet {
            if oldValue != resumeOnEnterForeground {
                applyConfiguration()
            }
        }
    }
    
    var trackMessageDisplayed: Bool? {
        didSet {
            if trackMessageDisplayed == true {
                ActionManager.shared.onMessageDisplayed(onMessageHandler(#function))
            } else {
                ActionManager.shared.onMessageDisplayed(nil)
            }
        }
    }
    
    var trackMessageDismissed: Bool? {
        didSet {
            if trackMessageDismissed == true {
                ActionManager.shared.onMessageDismissed(onMessageHandler(#function))
            } else {
                ActionManager.shared.onMessageDismissed(nil)
            }
        }
    }
    
    var trackMessageActions: Bool? {
        didSet {
            if trackMessageActions == true {
                ActionManager.shared.onMessageAction(onMessageActionHandler(#function))
            } else {
                ActionManager.shared.onMessageAction(nil)
            }
        }
    }
    
    lazy var onMessageHandler: ((String) -> (ActionContext) -> ()) = { handler in
        { context in
            if !Thread.isMainThread {
                Log.print("[ERROR]: onMessageHandler NOT running on main thread")
            }
            self.addAction(context: context, handler: handler)
        }
    }
    
    lazy var onMessageActionHandler: ((String) -> (String, ActionContext) -> ()) = { handler in
        { action, context in
            self.addAction(action: action, context: context, handler: handler)
        }
    }
    
    lazy var onMessageDismissed: ((ActionContext) -> ()) = { context in
        self.addAction(context: context, handler: #function)
    }
    
    func applyConfiguration() {
        ActionManager.shared.configuration = ActionManager.Configuration(dismissOnPushArrival: dismissOnPushArrival,
                                                                         resumeOnEnterForeground: resumeOnEnterForeground)
    }
    
    func prioritizationChoiceChanged(_ prioritization: MessagePrioritization?) {
        switch prioritization {
        case .all:
            ActionManager.shared.prioritizeMessages { contexts, trigger in
                Log.print("MessagePrioritization running on main thread: \(Thread.isMainThread)")
                return contexts
            }
        case .firstOnly:
            ActionManager.shared.prioritizeMessages { contexts, trigger in
                guard let first = contexts.first else {
                    return []
                }
                Log.print("MessagePrioritization running on main thread: \(Thread.isMainThread)")
                return [first]
            }
        case .allReversed:
            ActionManager.shared.prioritizeMessages { contexts, trigger in
                Log.print("MessagePrioritization running on main thread: \(Thread.isMainThread)")
                return contexts.reversed()
            }
        default:
            ActionManager.shared.prioritizeMessages(nil)
            break
        }
    }
    
    func triggerDelayedMessages() {
        ActionManager.shared.triggerDelayedMessages()
    }
    
    func addAction(context: ActionContext, handler: String) {
        addAction(action: nil, context: context, handler: handler)
    }
    
    func addAction(action: String?, context: ActionContext, handler: String) {
        let desc = ActionModel.description(from: context, handler: handler, action: action)
        eventsLog.append(desc)
    }
    
    func showEventLogs() -> UIViewController {
        let ctrl = TextAreaController()
        ctrl.title = "Action Logs"
        ctrl.message = eventsLog.joined(separator: ", \n")
        return ctrl
    }
    
    func resetEventLogs() {
        eventsLog.removeAll()
    }
    
    func showMessageQueue() -> UIViewController {
        var log = [String]()
        for ctx in queueContexts {
            log.append(ActionModel.description(from: ctx, handler: nil, action: nil))
        }
        
        let ctrl = TextAreaController()
        ctrl.title = "Queue"
        ctrl.message = log.joined(separator: ", \n")
        return ctrl
    }
    
    func showDelayedMessageQueue() -> UIViewController {
        var log = [String]()
        for ctx in delayedQueueContexts {
            log.append(ActionModel.description(from: ctx, handler: nil, action: nil))
        }
        
        let ctrl = TextAreaController()
        ctrl.title = "Delayed Queue"
        ctrl.message = log.joined(separator: ", \n")
        return ctrl
    }
    
    var queueContexts: [ActionContext] {
        getActionManagerQueueContexts("queue")
    }
    
    var delayedQueueContexts: [ActionContext] {
        getActionManagerQueueContexts("delayedQueue")
    }

    /// Accessing the ActionManager Queues which are private lazy properties of private type Queue
    /// The Queue holds a private array of the private type Action
    /// The Action holds a context
    func getActionManagerQueueContexts(_ queueName: String) -> [ActionContext] {
        let queue = Util.getPrivateValue(subject: ActionManager.shared, label: queueName, true, true)
        
        if let queue = queue {
            if let arr = Util.getPrivateValue(subject: queue, label: "queue") as? [Any] {
                return arr.map { action in
                    return Util.getPrivateValue(subject: action, label: "context") as? ActionContext
                }.compactMap { $0 }
            }
        }
        return []
    }
}
