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
            }
        }

        var image: UIImage? {
            switch self {
            case .home: return UIImage(systemName: "house")
            case .messages: return UIImage(systemName: "doc.richtext")
            case .variables: return UIImage(systemName: "number")
            case .inbox: return UIImage(systemName: "tray")
            case .events: return UIImage(systemName: "bell")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = Tab.allCases.map(viewController(for:))
    }

    func viewController(for tab: Tab) -> UIViewController {
        var vc: UIViewController

        switch tab {
        case .home:
            vc = HomeViewController()
        case .messages:
            vc = MessagesViewController()
        case .variables:
            vc = VariablesViewController()
        case .inbox:
            vc = InboxViewController()
        case .events:
            vc = EventsViewController()
        }

        vc.title = tab.name
        vc = UINavigationController(rootViewController: vc)

        if let navigationViewController = vc as? UINavigationController {
            navigationViewController.navigationBar.prefersLargeTitles = true
        }

        vc.tabBarItem = UITabBarItem(title: tab.name, image: tab.image, selectedImage: nil)

        return vc
    }
}
