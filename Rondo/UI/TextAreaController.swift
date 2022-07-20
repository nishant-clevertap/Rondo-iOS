//
//  TextAreaController.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Eureka

class TextAreaController: FormViewController {
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        build()
    }
    
    func build() {
        let section = Section(title)

        section <<< TextAreaRow() {
            $0.value = message
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 96)
        }
        
        form +++ section
    }
}
