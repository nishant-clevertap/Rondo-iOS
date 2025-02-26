//
//  MigrationViewController+Variables.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 10.05.23.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import Foundation
import Eureka
import CleverTapSDK

extension MigrationViewController {
    func buildVariables(_ instance: CleverTap) {
        defineVariables(instance)
        
        instance.onVariablesChanged { [weak self] in
            Log.print("[CleverTap] onVariablesChanged")
            self?.buildVariablesLabels()
        }
        var_string?.onValueChanged {
            Log.print("[CleverTap] var_string onValueChanged: \(self.var_string?.stringValue ?? "var_string is nil")")
        }
        
        buildVariablesLabels()
        buildVariablesActions(instance)
    }
    
    func defineVariables(_ instance: CleverTap) {
        // Primitives
        var_string = instance.defineVar(name: "var_string", string: "hello, world")
        var_int = instance.defineVar(name: "var_int", integer: 10)
        var_number = instance.defineVar(name: "var_number", number: NSNumber(value: 11.2))
        var_bool = instance.defineVar(name: "var_bool", boolean: true)
        
        // Dictionary
        var_dict = instance.defineVar(name: "var_dict", dictionary: [
            "nested_string": "hello, nested",
            "nested_double": 10.5
        ])
        // Dot notation
        var_dot = instance.defineVar(name: "dot_group.var_string", string: "hello, world")
        var_dot_dict = instance.defineVar(name: "dot_group.var_dict", dictionary: [
            "nested_float": 0.5,
            "nested_number": NSNumber(value: 32)
        ])
    }
    
    func buildVariablesLabels() {
        let section = Section("CleverTap Variables")
        
        section <<< LabelRow {
            $0.title = "var_string"
            $0.value = var_string?.stringValue
            $0.cell.detailTextLabel?.numberOfLines = 0
        }
        
        section <<< LabelRow {
            $0.title = "var_int"
            $0.value = var_int?.intValue().description
        }
        
        section <<< LabelRow {
            $0.title = "var_number"
            $0.value = var_number?.numberValue?.stringValue
        }
        
        section <<< LabelRow {
            $0.title = "var_bool"
            $0.value = var_bool?.boolValue().description
        }
        
        section <<< LabelRow {
            $0.title = "var_dict"
            $0.value = LPJSON.string(fromJSON: var_dict?.value)
            $0.cell.detailTextLabel?.numberOfLines = 0
        }
        
        section <<< LabelRow {
            $0.title = "dot_group.var_string"
            $0.value = var_dot?.stringValue
            $0.cell.textLabel?.numberOfLines = 0
            $0.cell.detailTextLabel?.numberOfLines = 0
        }
        
        section <<< LabelRow {
            $0.title = "dot_group.var_dict"
            $0.value = LPJSON.string(fromJSON: var_dot_dict?.value)
            $0.cell.textLabel?.numberOfLines = 0
            $0.cell.detailTextLabel?.numberOfLines = 0
        }
        
        form.removeAll {
            $0.header?.title == section.header?.title
        }
        form.insert(section, at: 1)
    }
    
    func buildVariablesActions(_ instance: CleverTap) {
        let section = Section("CleverTap Variables Actions")

        section <<< ButtonRow(){
            $0.title = "Fetch Variables"
        }.onCellSelection({ cell, row in
            instance.fetchVariables({ success in
                Log.print("[CleverTap] Fetch Variables success: \(success)")
            })
        })
        
        section <<< ButtonRow(){
            $0.title = "Sync Variables"
        }.onCellSelection({ cell, row in
            // Force sync in prod to support TestFlight
            instance.syncVariables(true)
        })
        
        form +++ section
    }
}
