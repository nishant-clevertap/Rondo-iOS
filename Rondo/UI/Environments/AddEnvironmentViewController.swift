//
//  AddEnvironmentViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

class AddEnvironmentViewController: FormViewController {

    let context = UIApplication.shared.appDelegate.context
    var environmentsViewController: EnvironmentsViewController?

    private enum Tags: String {
        case apiHostName
        case socketName
        case socketPort
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new Environment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddEnvironmentViewController.done))

        TextRow.defaultCellUpdate = { cell, row in
            if row.section?.form === self.form {
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }

        buildInfo()
    }

    func buildInfo() {
        let section = Section("Info")

        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())

        section <<< TextRow() {
            $0.tag = Tags.apiHostName.rawValue
            $0.title = "API Host URL"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }
        section <<< TextRow() {
            $0.tag = Tags.socketName.rawValue
            $0.title = "Socket URL"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }
        section <<< TextRow() {
            $0.tag = Tags.socketPort.rawValue
            $0.title = "Socket Port"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        form +++ section
    }

    @objc func done() {
        let errors = form.validate()
        if errors.count == form.allSections.first?.allRows.count {
            self.dismiss(animated: true) {
                if let viewController = self.environmentsViewController {
                    viewController.envs = self.context.envs
                }
            }
        }
        if errors.count == 0 {
            let env = LeanplumEnv(apiHostName: formValue(tag: .apiHostName),
                                  ssl: true,
                                  socketHostName: formValue(tag: .socketName),
                                  socketPort: Int(formValue(tag: .socketPort)) ?? 80)
            context.envs.append(env)
            self.dismiss(animated: true)
        }
    }

    private func formValue(tag: Tags) -> String {
        let row = form.rowBy(tag: tag.rawValue) as? TextRow
        return row?.value ?? ""
    }
}

extension AddEnvironmentViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        if let presentationController = navigationController?.presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
    }
}
