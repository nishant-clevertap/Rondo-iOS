//
//  InboxViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class InboxViewController: FormViewController {
    private let refreshControl = UIRefreshControl()
    private let segmentedControl = UISegmentedControl(items: ["All", "Unread"])

    let messagesSection = Section("Messages")

    override func viewDidLoad() {
        super.viewDidLoad()

        LabelRow.defaultRowInitializer = { row in
            row.cellStyle = .subtitle
            row.cell.height = { 60 }
            row.cell.selectionStyle = .default
        }
        LabelRow.defaultCellUpdate = { cell, row in
            cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        }

        addRefreshControl()
        addSegmentedControl()

        form +++ messagesSection

        build()

        Leanplum.inbox().onChanged {
            self.build()
        }

        Leanplum.inbox().onForceContentUpdate{ success in
            self.build()
            self.refreshControl.endRefreshing()
        }
    }

    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(InboxViewController.didPullToRefresh), for: .valueChanged)
        refreshControl.isHidden = true

        tableView?.addSubview(refreshControl)
    }

    func addSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(InboxViewController.didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.sizeToFit()

        navigationItem.titleView = segmentedControl
    }

    @objc func didChangeSegment() {
        build()
    }

    @objc func didPullToRefresh() {
        Leanplum.forceContentUpdate()
    }

    func build() {
        messagesSection.removeAll()

        let messages = segmentedControl.selectedSegmentIndex == 0 ? Leanplum.inbox()?.allMessages() : Leanplum.inbox()?.unreadMessages()

        if let messages = messages as? [LPInboxMessage] {
            for message in messages {
                buildMessage(message: message)
            }
        }
    }

    override func insertAnimation(forRows rows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    override func deleteAnimation(forRows rows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    override func reloadAnimation(oldRows: [BaseRow], newRows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    func buildMessage(message: LPInboxMessage) {
        messagesSection <<< MessageRow {
            $0.value = message
        }.onCellSelection { cell, row in
            message.read()
            row.deselect(animated: true)
        }
    }

    func fetchImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}
