//
//  TabViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    enum Tab: CaseIterable {
        case home
        case migration
        case variables
        case events
        case messages
        case inbox

        var name: String {
            switch self {
            case .home: return "Home"
            case .messages: return "Messages"
            case .variables: return "Variables"
            case .inbox: return "Inbox"
            case .events: return "Events"
            case .migration: return "Migration"
            }
        }

        var image: UIImage? {
            switch self {
            case .home: return UIImage(systemName: "house")
            case .messages: return UIImage(systemName: "doc.richtext")
            case .variables: return UIImage(systemName: "number")
            case .inbox: return UIImage(systemName: "tray")
            case .events: return UIImage(systemName: "bell")
            case .migration: return UIImage(systemName: "arrow.merge")
            }
        }
        
        init(_ name: String) {
            let value = Self.allCases.first {
                $0.name == name
            }
            self = value ?? .home
        }
    }
    
    var orderedTabs: [String]? {
        get {
            UserDefaults.standard.object(forKey: "ordered_tabs_titles") as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ordered_tabs_titles")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if var tabs = orderedTabs {
            var tabsSet = Set(tabs)
            Tab.allCases.forEach {
                if tabsSet.insert($0.name).inserted {
                    tabs.append($0.name)
                }
            }
            viewControllers =  tabs.map {
                viewController(for: Tab($0))
            }
        } else {
            viewControllers = Tab.allCases.map(viewController(for:))
        }
    }

    func viewController(for tab: Tab) -> UIViewController {
        var vc: UIViewController

        switch tab {
        case .home:
            vc = HomeViewController(style: .insetGrouped)
        case .messages:
            vc = MessagesViewController(style: .insetGrouped)
        case .variables:
            vc = VariablesViewController(style: .insetGrouped)
        case .inbox:
            vc = InboxViewController(style: .insetGrouped)
        case .events:
            vc = EventsViewController(style: .insetGrouped)
        case .migration:
            vc = MigrationViewController(style: .insetGrouped)
        }

        vc.title = tab.name
        vc = UINavigationController(rootViewController: vc)

        if let navigationViewController = vc as? UINavigationController {
            navigationViewController.navigationBar.prefersLargeTitles = true
        }

        vc.tabBarItem = UITabBarItem(title: tab.name, image: tab.image, selectedImage: nil)

        return vc
    }
    
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if changed {
            orderedTabs = items.map { $0.title }.compactMap{ $0 }
        }
    }
}
