//
//  LeanplumDeferIAM.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 28.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import Foundation

struct LeanplumDeferIAM: Equatable, Codable {
    
    let enabled: Bool
    let actionNames: [String]
    let viewControllers: [String]
    
    static func setup() {
        NotificationCenter.default.addObserver(forName: UserDefaults.observerNotificationNameFor(key: UserDefaults.DefaultKey.deferIAM), object: nil, queue: nil, using: {
            (notification) in
            
            LeanplumDeferIAM.configure()
        })
        
        LeanplumDeferIAM.configure()
    }
    
    static private func configure() {
        let df = UserDefaults.standard.deferIAM
        
        if let deferIam = df, deferIam.enabled {
            let names = deferIam.actionNames
            let forControllers = deferIam.viewControllers
            
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
                }
            }
        } else {
            Leanplum.deferMessagesWithActionNames([])
            Leanplum.deferMessagesForViewControllers([])
        }
    }
    
    static private func capitalizeFirstLetter(word:String) -> String {
        let first = String(word.prefix(1)).capitalized
        let other = String(word.dropFirst())
        return first + other
    }
}
