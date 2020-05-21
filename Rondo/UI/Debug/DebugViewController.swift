//
//  DebugViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 20/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class DebugViewController: FormViewController {

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
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Vars"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Update rules"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Event rules"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Event rules"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Variants"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        section <<< ButtonRow() {
            $0.cellStyle = .value1
            $0.title = "Regions"
            $0.presentationMode = .show(controllerProvider: .callback(builder: { () -> UIViewController in
                return UIViewController()
            }), onDismiss: nil)
        }

        form +++ section
    }
}
