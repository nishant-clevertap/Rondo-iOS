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
    
    let weapons = Var(name: "weapons", dictionary: [:])
    
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
        
        buildDashbordVarGroupSection()
    }
    
    func buildDashbordVarGroupSection () {
        // Example for Variables Group defined on the Dashboard
        // weapons (group)
        // -> daggers (group)
        // -> -> magic_dagger (group)
        // -> -> -> name
        // -> -> -> damage
        // -> -> -> level
        // -> -> -> crit
        // -> -> -> icon (image file)
        let name = weapons.object(forKeyPathComponents: ["daggers", "magic_dagger", "name"]) as? String
        let damage = weapons.object(forKeyPathComponents: ["daggers", "magic_dagger", "damage"]) as? NSNumber
        let level = weapons.object(forKeyPathComponents: ["daggers", "magic_dagger", "level"]) as? NSNumber
        let crit = weapons.object(forKeyPathComponents: ["daggers", "magic_dagger", "crit"]) as? String
        let icon = weapons.object(forKeyPathComponents: ["daggers", "magic_dagger", "icon"]) as? String
        
        var weaponImage:UIImage?
        
        if let fileName = icon {
            // try to download the image
            // if the image is already downloaded it will not trigger the onComplete callback
            let willDownload = LPFileManager.maybeDownloadFile(fileName, defaultValue: "", onComplete: {

                // Get the row from the form
                let imageRow = self.form.allRows.last as? ImageRow
                
                weaponImage = self.getImageFile(fileName)
                if let imgr = imageRow {
                    // Change the image and update the cell
                    imgr.value = weaponImage
                    imgr.updateCell()
                }
            })

            if !willDownload {
                weaponImage = self.getImageFile(fileName)
            }
        }
        
        let section = Section(name)
        section <<< LabelRow {
            $0.title = "Level"
            $0.value = level?.description
        }
        section <<< LabelRow {
            $0.title = "Damage"
            $0.value = damage?.description
        }
        section <<< LabelRow {
            $0.title = "Critical Chance"
            $0.value = crit?.description
        }
        
        section <<< ImageRow {
            $0.value = weaponImage
        }.cellSetup { (cell, row) in
            //  Change the cell's height
            cell.height = { return CGFloat(200) }
        }
        
        form +++ section
    }
    
    func getImageFile(_ fileName: String) -> UIImage? {
        let fl = LPFileManager.fileValue(fileName, withDefaultValue: fileName)
        if let file = fl {
            let img = UIImage.init(contentsOfFile: file)
            return img
        }
        return nil
    }
}
