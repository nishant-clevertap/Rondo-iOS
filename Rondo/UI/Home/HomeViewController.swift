//
//  HomeViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum
import AppTrackingTransparency
import AdSupport

class HomeViewController: FormViewController {
    let context = UIApplication.shared.appDelegate.context

    var app: LeanplumApp? {
        didSet {
            if app != oldValue {
                build()
            }
        }
    }
    var env: LeanplumEnv? {
        didSet {
            if env != oldValue {
                form.rowBy(tag: "env")?.reload()
            }
        }
    }
    var logLevel: Leanplum.LogLevel = UserDefaults.standard.logLevel {
        didSet {
            if logLevel != oldValue {
                context.logLevel = logLevel
                form.rowBy(tag: "logLevel")?.reload()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        env = context.env
        app = context.app
        logLevel = context.logLevel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bug"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(HomeViewController.didTapDebugButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        env = context.env
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
        
        if #available(iOS 14, *) {
            // Objective-C templates
            // LPAdsAskToAskMessageTemplate.defineAction()
            // LPAdsTrackingActionTemplate.defineAction()
            AdsAskToAskMessageTemplate.defineAction()
            AdsTrackingActionTemplate.defineAction()
            
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                // Uncomment to use IDFA
                // Leanplum.setDeviceId(AdsTrackingManager.advertisingIdentifierString)
            }
        } else {
            // Leanplum.setDeviceId(AdsTrackingManager.advertisingIdentifierString)
        }
        
        Leanplum.onStartResponse { success in
            self.buildUserInfo()
            self.form.allSections.forEach { $0.reload() }
        }
    }

    func buildApps() {
        let section = Section("App")

        section <<< ButtonRow() {
            $0.title = "App"
            $0.tag = "app"
            $0.cellStyle = .value1
            $0.value = app?.name
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return AppsViewController(style: .insetGrouped)
            }), onDismiss: nil)
            $0.displayValueFor = {
                return $0
            }
        }

        section <<< ButtonRow() {
            $0.title = "Environment"
            $0.tag = "env"
            $0.cellStyle = .value1
            $0.value = env?.apiHostName
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return EnvironmentsViewController(style: .insetGrouped)
            }), onDismiss: nil)
            $0.displayValueFor = {
                return $0
            }
        }.cellUpdate({ (cell, row) in
            row.value = self.env?.apiHostName
        })

        section <<< ActionSheetRow<LeanplumApp.Mode> {
            $0.title = "Mode"
            $0.value = app?.mode
            $0.options = [.development, .production]
            $0.selectorTitle = "Choose mode"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }.onChange { row in
            self.app?.mode = row.value ?? .development
            self.context.app?.mode = row.value ?? .development
            self.build()
        }.cellUpdate { (cell, row) in
            cell.accessoryType = .disclosureIndicator
        }
        
        section <<< ActionSheetRow<Leanplum.LogLevel> {
            $0.title = "Log level"
            $0.tag = "logLevel"
            $0.value = self.logLevel
            $0.options = [.off, .debug, .info, .error]
            $0.selectorTitle = "Set log level"
        }.onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }.onChange { row in
            self.logLevel = row.value ?? .debug
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
            $0.value = Leanplum.Constants.shared().sdkVersion
        }
        section <<< LabelRow {
            $0.title = "API host"
            $0.value = env?.apiHostName
        }
        section <<< LabelRow {
            $0.title = "API SSL"
            $0.value = env?.ssl.description
        }
        section <<< LabelRow {
            $0.title = "Socket host"
            $0.value = env?.socketHostName
        }
        section <<< LabelRow {
            $0.title = "Socket port"
            $0.value = env?.socketPort.description
        }
        section <<< LabelRow {
            $0.title = "Development mode"
            $0.value = Leanplum.Constants.shared().isDevelopmentModeEnabled.description
        }.cellUpdate { (cell, row) in
            row.value = Leanplum.Constants.shared().isDevelopmentModeEnabled.description
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
