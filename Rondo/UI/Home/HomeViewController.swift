//
//  HomeViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class HomeViewController: FormViewController {

    var app: LeanplumApp? {
        didSet {
            if app != oldValue {
                build()
            }
        }
    }

    let context = UIApplication.shared.appDelegate.context

    override func viewDidLoad() {
        super.viewDidLoad()

        app = context.app

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bug"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(HomeViewController.didTapDebugButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        app = context.app
    }

    @objc func didTapDebugButton() {
        let vc = UINavigationController(rootViewController: DebugViewController())
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true)
    }

    func build() {
        form.removeAll()

        buildApps()
        buildAppInfo()
        buildSettingsInfo()

        UIApplication.shared.appDelegate.context.start(with: app) { success in
             self.buildUserInfo()
        }
    }

    func buildApps() {
        let section = Section("App")

        section <<< ButtonRow() {
            $0.title = "App"
            $0.cellStyle = .value1
            $0.value = app?.name
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return AppsViewController()
            }), onDismiss: nil)
            $0.displayValueFor = {
                return $0
            }
        }

        section <<< ActionSheetRow<LeanplumApp.Environment> {
            $0.title = "Environment"
            $0.value = app?.environment
            $0.options = [.development, .production]
            $0.selectorTitle = "Choose environment"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }.onChange { row in
            self.app?.environment = row.value ?? .development
            self.build()
        }.cellUpdate { (cell, row) in
            cell.accessoryType = .disclosureIndicator
        }

        form +++ section
    }

    func buildAppInfo() {
        let section = Section("Info")
        section.tag = "info"

        section <<< LabelRow {
            $0.title = "App name"
            $0.value = app?.name
        }
        section <<< LabelRow {
            $0.title = "App Id"
            $0.value = app?.appId
        }
        section <<< LabelRow {
            $0.title = "Production key"
            $0.value = app?.productionKey
        }
        section <<< LabelRow {
            $0.title = "Development key"
            $0.value = app?.developmentKey
        }

        form +++ section
    }

    func buildSettingsInfo() {
        let section = Section("Settings")

        section <<< LabelRow {
            $0.title = "SDK version"
            $0.value = LPConstantsState.shared()?.sdkVersion
        }
        section <<< LabelRow {
            $0.title = "API host"
            $0.value = LPConstantsState.shared()?.apiHostName
        }
        section <<< LabelRow {
            $0.title = "API SSL"
            $0.value = LPConstantsState.shared()?.apiSSL.description
        }
        section <<< LabelRow {
            $0.title = "Socket host"
            $0.value = LPConstantsState.shared()?.socketHost
        }
        section <<< LabelRow {
            $0.title = "Socket port"
            $0.value = LPConstantsState.shared()?.socketPort.description
        }
        section <<< LabelRow {
            $0.title = "Development mode"
            $0.value = LPConstantsState.shared()?.isDevelopmentModeEnabled.description
        }

        form +++ section
    }

    func buildUserInfo() {
        let section = Section("User info")

        section <<< LabelRow {
            $0.title = "User id"
            $0.value = Leanplum.userId()
        }
        section <<< LabelRow {
            $0.title = "Device id"
            $0.value = Leanplum.deviceId()
        }

        let index = form.firstIndex { $0.tag == "info" } ?? 1
        form.insert(section, at: index + 1)
    }
}
