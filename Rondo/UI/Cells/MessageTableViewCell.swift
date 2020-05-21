//
//  MessageRow.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

final class MessageRow: Row<MessageTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<MessageTableViewCell>(nibName: "MessageTableViewCell")
    }
}

final class MessageTableViewCell: Cell<LPInboxMessage>, CellType {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageSubtitleLabel: UILabel!

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
        super.setup()

        selectionStyle = .default
        messageImageView.contentMode = .scaleAspectFit
    }

    override func update() {
        super.update()

        guard let message = row.value else {
            return
        }

        messageTitleLabel.text = message.title()
        messageSubtitleLabel.text = message.subtitle()
        if let image = fetchImage(url: message.imageURL()) {
            messageImageView.image = image
        }
    }

    func fetchImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}
