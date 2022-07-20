//
//  DebugViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 20/03/2020.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class DebugViewController: FormViewController {
    let savedSdkVersionKey = "savedSdkVersion"
    private var savedSdkVersion: String {
        get {
            UserDefaults.standard.string(forKey: savedSdkVersionKey) ?? "1.0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: savedSdkVersionKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Debug"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DebugViewController.close))

        build()
    }

    @objc func close() {
        self.dismiss(animated: true)
    }

    func build() {
        let section = Section("Var Cache")

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Messages"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                ActionsController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Vars"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                let ctrl = TextAreaController()
                ctrl.title = "Vars JSON"
                ctrl.message = LPJSON.string(fromJSON: VarCache.shared().diffs())
                return ctrl
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Secured Vars"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                let ctrl = TextAreaController()
                ctrl.title = "Secured Vars JSON"
                ctrl.message = LPJSON.string(fromJSON: VarCache.shared().securedVars())
                return ctrl
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Variants"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                let ctrl = TextAreaController()
                ctrl.title = "Variants JSON"
                ctrl.message = "Not supported yet"
//                let variants = VarCache.shared().variants()
//                ctrl.message = LPJSON.string(fromJSON: variants)
                return ctrl
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Regions"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                let ctrl = TextAreaController()
                ctrl.title = "Regions JSON"
                ctrl.message = LPJSON.string(fromJSON: VarCache.shared().regions())
                return ctrl
            }), onDismiss: nil)
        }

        form +++ section
        
        let resetSection = Section("Reset")
        
        resetSection <<< ButtonRow {
            $0.title = "Delete events data"
        }.onCellSelection({ (cell, row) in
            LPEventDataManager.deleteEvents(withLimit: LPEventDataManager.count())
        })
        
        resetSection <<< ButtonRow {
            $0.title = "Reset"
        }.onCellSelection({ (cell, row) in
            // Calls private static reset method
            Leanplum.perform(NSSelectorFromString("reset"))
        })
        
        resetSection <<< ButtonRow {
            $0.title = "Delete file cache"
        }.onCellSelection({ (cell, row) in
            let currentVersion = self.savedSdkVersion
            // force change of version
            self.savedSdkVersion = "1.0-force"
            LPFileManager.clearCacheIfSDKUpdated()
            // restore version
            self.savedSdkVersion = currentVersion
        })
        
        form +++ resetSection
    }
}

class ActionsController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        build()
    }
    
    func build() {
        let section = Section(title)
        
        let messages = ActionManager.shared.messages
        
        for (key, value) in messages {
            let config = value as? [AnyHashable: Any]
            let actionName = config?[LP_PARAM_ACTION] ?? "Unknown"
            let title = "\(key): \(actionName)"
            section <<< ButtonRow() { (row) in
                row.title = title
                row.cellStyle = .value1
                row.value = key as? String
                row.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                    let ctrl = TextAreaController()
                    ctrl.title = row.title
                    ctrl.message = LPJSON.string(fromJSON: ActionManager.shared.messages[row.value!])
                    return ctrl
                }), onDismiss: nil)
                row.displayValueFor = {
                    return $0
                }
            }
        }

        form +++ section
    }
}
