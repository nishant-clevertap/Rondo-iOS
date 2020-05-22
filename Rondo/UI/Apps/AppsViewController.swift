//
//  AppsViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

class AppsViewController: FormViewController {

    let context = UIApplication.shared.appDelegate.appContext
    var apps: [LeanplumApp] = [] {
        didSet {
            if apps != oldValue {
                build()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose an App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AppsViewController.addApp))

        apps = UIApplication.shared.appDelegate.appContext.apps
    }

    func build() {
        form.removeAll()
        
        let section = SelectableSection<ListCheckRow<LeanplumApp>>("Apps", selectionType: .singleSelection(enableDeselection: false)) {
            $0.tag = "apps"
        }

        for app in apps {
            section <<< ListCheckRow<LeanplumApp>() {
                $0.tag = app.name
                $0.title = app.name
                $0.selectableValue = app
                $0.value = app == self.context.app ? app : nil
            }.onChange{ (row) in
                self.context.app = row.value
            }
        }

        form +++ section
    }

    @objc func addApp() {
        let addAppViewController = AddAppViewController()
        addAppViewController.appsViewController = self
        let viewController = UINavigationController(rootViewController: addAppViewController)
        present(viewController, animated: true)
    }
}
