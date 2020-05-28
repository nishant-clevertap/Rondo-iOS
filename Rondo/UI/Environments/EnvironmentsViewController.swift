//
//  EnvironmentsViewController.swift
//  Rondo-iOS
//
//  Created by Milos Jakovljevic on 28/05/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

class EnvironmentsViewController: FormViewController {

    let context = UIApplication.shared.appDelegate.context
    var envs: [LeanplumEnv] = [] {
        didSet {
            if envs != oldValue {
                build()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose an env"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(EnvironmentsViewController.addEnvironment))

        envs = UIApplication.shared.appDelegate.context.envs
    }

    func build() {
        form.removeAll()

        let section = SelectableSection<ListCheckRow<LeanplumEnv>>(header: "Environments",
                                                                   footer: "Rondo app needs to be restarted for environment change to take effect.",
                                                                   selectionType: .singleSelection(enableDeselection: false)) {
            $0.tag = "envs"
        }

        for env in envs {
            section <<< ListCheckRow<LeanplumEnv>() {
                $0.tag = env.apiHostName
                $0.title = env.apiHostName
                $0.selectableValue = env
                $0.value = env == self.context.env ? env : nil
            }.onChange{ (row) in
                self.context.env = row.value
            }
        }

        form +++ section
    }

    @objc func addEnvironment() {
//        let viewController = UINavigationController(rootViewController: AddAppViewController())
//        viewController.presentationController?.delegate = self
//        present(viewController, animated: true)
    }
}

extension EnvironmentsViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        apps = UIApplication.shared.appDelegate.context.apps
    }
}

