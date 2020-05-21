//
//  AddAppViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 07/04/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

class AddAppViewController: FormViewController {

    let context = UIApplication.shared.appDelegate.context

    private enum Tags: String {
        case name
        case appId
        case production
        case development
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddAppViewController.done))

        TextRow.defaultCellUpdate = { cell, row in
            if row.section?.form === self.form {
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }

        buildInfo()
        buildAddWithCamera()
    }

    func buildInfo() {
        let section = Section("Info")

        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())

        section <<< TextRow() {
            $0.tag = Tags.name.rawValue
            $0.title = "App name"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.appId.rawValue
            $0.title = "App Id"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.development.rawValue
            $0.title = "Development key"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        section <<< TextRow() {
            $0.tag = Tags.production.rawValue
            $0.title = "Production key"
            $0.add(ruleSet: rules)
            $0.validationOptions = .validatesOnChangeAfterBlurred
        }

        form +++ section
    }

    func buildAddWithCamera() {
        let section = Section()

        section <<< ButtonRow() {
            $0.title = "Scan QR code"
        }.onCellSelection({ (cell, row) in
            let viewController = ScannerViewController()
            viewController.delegate = self.parse(code:)
            self.present(viewController, animated: true)
        })

        form +++ section
    }

    @objc func done() {
        let errors = form.validate()
        if errors.count == 0 {
            let app = LeanplumApp(name: formValue(tag: .name),
                                  appId: formValue(tag: .appId),
                                  productionKey: formValue(tag: .production),
                                  developmentKey: formValue(tag: .development))
            context.apps.append(app)
            
            self.dismiss(animated: true) {
                if let viewController = self.presentingViewController as? AppsViewController {
                    viewController.apps = self.context.apps
                }
            }
        }
    }

    private func formValue(tag: Tags) -> String {
        let row = form.rowBy(tag: tag.rawValue) as? TextRow
        return row?.value ?? ""
    }

    func parse(code: String) {
        if let data = code.data(using: .utf8) {
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }

                let appId = form.rowBy(tag: Tags.appId.rawValue) as? TextRow
                appId?.value = json["app_id"] as? String

                let development = form.rowBy(tag: Tags.development.rawValue) as? TextRow
                development?.value = json["development"] as? String

                let production = form.rowBy(tag: Tags.production.rawValue) as? TextRow
                production?.value = json["production"] as? String

            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
