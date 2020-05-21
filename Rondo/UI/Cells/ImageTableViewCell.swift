//
//  ImageTableViewCell.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka

final class ImageRow: Row<ImageTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ImageTableViewCell>(nibName: "ImageTableViewCell")
    }
}

class ImageTableViewCell: Cell<UIImage>, CellType {

    @IBOutlet weak var cellImageView: UIImageView!

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

        cellImageView.image = row.value
    }
}
