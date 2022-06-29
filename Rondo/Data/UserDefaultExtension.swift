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
        case logLevel
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
    
    var logLevel: Leanplum.LogLevel {
        get {
            if let value = self[.logLevel] as? UInt,
               let level = Leanplum.LogLevel.init(rawValue: value) {
                return level
            }
            return .debug
        }
        set {
            let oldValue = logLevel
            self[.logLevel] = newValue.rawValue
            if newValue != oldValue {
                postObserverNotificationFor(key: .logLevel)
            }
        }
    }
}
