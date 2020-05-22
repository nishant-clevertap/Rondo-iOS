//
//  KeyValueTableViewCell.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 19/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

final class KeyValueRow: Row<KeyValueTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<KeyValueTableViewCell>(nibName: "KeyValueTableViewCell")
    }
}

class KeyValueTableViewCell: Cell<KeyValue>, CellType {

    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
        super.setup()

        selectionStyle = .none
    }

    override func update() {
        super.update()

        guard let keyValue = row.value else {
            return
        }

        if let title = keyValue.title {
            parameterLabel.text = title
        }
        if let key = keyValue.key {
            keyTextField.text = key
        }
        if let value = keyValue.value {
            valueTextField.text = value
        }
    }
}

struct KeyValue: Equatable {
    var title: String?
    var key: String?
    var value: String?
}
