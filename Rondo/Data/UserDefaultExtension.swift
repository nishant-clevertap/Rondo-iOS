//
//  UserDefaultExtension.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit

extension UserDefaults {

    enum DefaultKey: String, CaseIterable {
        case apps
        case app
        case envs
        case env
        case useUNUserNotificationCenterDelegate
    }

    static func observerNotificationNameFor(key: DefaultKey) -> Notification.Name {
        return Notification.Name(rawValue: key.rawValue + "DidChange")
    }

    private subscript(key: DefaultKey) -> Any? {
        get { return object(forKey: key.rawValue) }
        set { set(newValue, forKey: key.rawValue) }
    }

    fileprivate func postObserverNotificationFor(key: DefaultKey) {
        NotificationCenter.default.post(name: UserDefaults.observerNotificationNameFor(key: key), object: self)
    }

    func clear() {
        DefaultKey.allCases.forEach { self[$0] = nil }
    }

    var apps: [LeanplumApp] {
        get {
            if let data = self[.apps] as? Data {
                return (try? JSONDecoder().decode([LeanplumApp].self, from: data)) ?? []
            }
            return []
        }
        set {
            let oldValue = apps
            self[.apps] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .apps)
            }
        }
    }

    var envs: [LeanplumEnv] {
        get {
            if let data = self[.envs] as? Data {
                return (try? JSONDecoder().decode([LeanplumEnv].self, from: data)) ?? []
            }
            return []
        }
        set {
            let oldValue = envs
            self[.envs] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .envs)
            }
        }
    }

    var app: LeanplumApp? {
        get {
            if let data = self[.app] as? Data {
                return try? JSONDecoder().decode(LeanplumApp.self, from: data)
            }
            return nil
        }
        set {
            let oldValue = app
            self[.app] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .app)
            }
        }
    }

    var env: LeanplumEnv? {
        get {
            if let data = self[.env] as? Data {
                return try? JSONDecoder().decode(LeanplumEnv.self, from: data)
            }
            return nil
        }
        set {
            let oldValue = env
            self[.env] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .env)
            }
        }
    }
    
    var useUNUserNotificationCenterDelegate: Bool {
        get {
            if let data = self[.useUNUserNotificationCenterDelegate] as? Data {
                return (try? JSONDecoder().decode(Bool.self, from: data)) ?? false
            }
            return false
        }
        set {
            let oldValue = useUNUserNotificationCenterDelegate
            self[.useUNUserNotificationCenterDelegate] = try? JSONEncoder().encode(newValue)
            if newValue != oldValue {
                postObserverNotificationFor(key: .useUNUserNotificationCenterDelegate)
            }
        }
    }
}
