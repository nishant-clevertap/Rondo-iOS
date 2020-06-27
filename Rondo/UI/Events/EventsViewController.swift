//
//  EventsViewController.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 18/03/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

import UIKit
import Eureka
import Leanplum

class EventsViewController: FormViewController {
    private let segmentedControl = UISegmentedControl(items: ["Events", "Triggers"])

    override func viewDidLoad() {
        super.viewDidLoad()

        LabelRow.defaultCellSetup = { row, cell in
            row.selectionStyle = .default
        }
        LabelRow.defaultCellUpdate = { row, cell in
            cell.deselect(animated: true)
        }

        addSegmentedControl()
        buildEvents()
    }

    func addSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(EventsViewController.didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.sizeToFit()

        navigationItem.titleView = segmentedControl
    }

    @objc func didChangeSegment() {
        title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        if segmentedControl.selectedSegmentIndex == 0 {
            buildEvents()
        } else {
            buildTriggers()
        }
    }
}

// MARK: - Events
extension EventsViewController {

    func buildEvents() {
        form.removeAll()

        buildTrack()
        buildAdvance()
        buildUserId()
        buildUserAttributes()
    }

    func buildTrack() {
        let section = Section(header: "Track", footer: "Add params that will be sent as part of the track event")

        section <<< AccountRow {
            $0.title = "Event name"
            $0.placeholder = "enter name"
        }
        section <<< KeyValueRow {
            $0.value = KeyValue()
        }
        section <<< ButtonRow {
            $0.title = "Add param"
        }.onCellSelection { (cell, row) in
            let kvrow = KeyValueRow {
                $0.value = KeyValue()
            }
            try? section.insert(row: kvrow, after: section.allRows[section.allRows.count - 2])
        }
        form +++ section

        let sendSection = Section()
        sendSection <<< ButtonRow {
            $0.title = "Send event"
        }.onCellSelection { (cell, row) in

            var event: String?
            var params: [String: Any] = [:]

            for row in section.allRows {
                if let row = row as? AccountRow {
                    event = row.value
                }
                if let row = row as? KeyValueRow {
                    if let key = row.cell.keyTextField.text, let value = row.cell.valueTextField.text {
                        params[key] = value
                    }
                }
            }

            Leanplum.track(event!, params: params)
        }

        form +++ sendSection
    }

    func buildAdvance() {
        let section = Section("Advance to state")

        section <<< AccountRow {
            $0.title = "State"
            $0.placeholder = "enter state"
            $0.tag = "state"
        }
        section <<< ButtonRow {
            $0.title = "Send state"
        }.onCellSelection { (cell, row) in
            let accountRow: AccountRow? = section.rowBy(tag: "state")
            if let value = accountRow?.value {
                Leanplum.advance(state: value)
            }
        }
        form +++ section
    }

    func buildUserId() {
        let section = Section("User ID")

        section <<< AccountRow {
            $0.title = "User ID"
            $0.placeholder = "enter id"
            $0.tag = "userid"
        }

        section <<< ButtonRow {
            $0.title = "Set UserID"
        }.onCellSelection { (cell, row) in
            let accountRow: AccountRow? = section.rowBy(tag: "userid")
            if let value = accountRow?.value {
                Leanplum.setUserId(value)
            }
        }
        form +++ section
    }

    func buildUserAttributes() {
        let section = Section("User Attributes")

        section <<< AccountRow {
            $0.tag = "user_attribute_key"
            $0.title = "Key"
            $0.placeholder = "enter key"
        }

        section <<< AccountRow {
            $0.tag = "user_attribute_value"
            $0.title = "Value"
            $0.placeholder = "enter value"
        }

        section <<< ButtonRow {
            $0.title = "Set user attributes"
        }.onCellSelection { cell, row in

            let keyRow: AccountRow? = section.rowBy(tag: "user_attribute_key")
            let valueRow: AccountRow? = section.rowBy(tag: "user_attribute_value")

            if let key = keyRow?.value, let value = valueRow?.value {
                let attributes: [String : Any] = [key : value]
                Leanplum.setUserAttributes(attributes)
            }
        }
        form +++ section
    }
}

// MARK: - Triggers
extension EventsViewController {

    func buildTriggers() {
        form.removeAll()

        let section = Section("Triggers")

        section <<< LabelRow {
            $0.title = "Track"
            $0.value = "testEvent"
        }.onCellSelection { row, cell in
            Leanplum.track(cell.value!)
        }

        section <<< LabelRow {
            $0.title = "Advance"
            $0.value = "testState"
        }.onCellSelection { row, cell in
            Leanplum.advance(state: cell.value!)
        }

        section <<< LabelRow {
            $0.title = "SetUserAttribute"
            $0.value = "{ age: \"(random)\" }"
        }.onCellSelection { row, cell in
            Leanplum.setUserAttributes(["age": String(arc4random())])
        }

        form +++ section

        buildLimits()
        buildChains()
        buildPriorities()
    }

    func buildLimits() {
        let section = Section(header: "Limits", footer: "Limited by set amount per session or lifetime")

        section <<< LabelRow {
            $0.title = "Session Limit"
            $0.value = "3"
        }.onCellSelection { row, cell in
            Leanplum.advance(state: "sessionLimit")
        }

        section <<< LabelRow {
            $0.title = "Lifetime Limit"
            $0.value = "3"
        }.onCellSelection { row, cell in
            Leanplum.advance(state: "lifetimeLimit")
        }

        form +++ section
    }

    func buildChains() {
        let section = Section(header: "Chained messages", footer: "Messages that are chained one to another")

        section <<< LabelRow {
            $0.title = "Chained message"
            $0.value = "chainedInApp"
        }.onCellSelection { row, cell in
            Leanplum.track(cell.value!)
        }

        form +++ section
    }

    func buildPriorities() {
        let section = Section(header: "Priorities", footer: "Messages that have different priorities")

        section <<< LabelRow {
            $0.title = "Track"
            $0.value = "DifferentPrioritySameTime"
        }.onCellSelection { row, cell in
            Leanplum.track(cell.value!)
        }

        form +++ section
    }

}
