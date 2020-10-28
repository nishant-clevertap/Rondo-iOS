//
//  VariablesViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class VariablesViewController: FormViewController {

    let varString = Var(name: "varString", string: "This is a local string.")
    let varNumber = Var(name: "varNumber", number: 0)
    let varBool = Var(name: "varBool", boolean: false)
    let varFile = Var(name: "varFile", file: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        Leanplum.onVariablesChanged {
            self.build()
        }

        build()
    }

    func build() {
        form.removeAll()

        let section = Section(header: "Variables", footer: "Variables are being fetch with values from server. Set these variable values for the connected app to see them change here")

        section <<< LabelRow {
            $0.title = "varString"
            $0.value = varString.stringValue
        }

        section <<< LabelRow {
            $0.title = "varNumber"
            $0.value = varNumber.numberValue?.stringValue
        }

        section <<< LabelRow {
            $0.title = "varBool"
            $0.value = varNumber.boolValue().description
        }

        section <<< LabelRow {
            $0.title = "varFile"
            $0.value = varFile.stringValue
        }

        section <<< ImageRow {
            $0.value = varFile.imageValue()
        }.cellSetup { (cell, row) in
            //  Change the cell's height
            cell.height = { return CGFloat(200) }
        }
        
        section <<< ButtonRow {
            $0.title = "Force Content Update"
        }.onCellSelection({ (cell, row) in
            Leanplum.forceContentUpdate({
                self.build()
            })
        })

        form +++ section
    }
}
